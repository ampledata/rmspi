# Makefile for botlib - Orion Python Bot Library.
#
# Author:: Greg Albrecht <gba@orionlabs.io>
# Copyright:: Copyright 2017 Orion Labs, Inc.
# License:: All rights reserved. Do not redistribute.
#


.DEFAULT_GOAL := all


all: resin_push

local_push:
	cat Dockerfile.template | sed s/%%RESIN_MACHINE_NAME%%/raspberrypi3/g > Dockerfile
	sudo resin local push 58f8f51.local -s .

resin_push:
	git push resin master

rebuild:
	git commit --allow-empty -m "Trigger notification"
	git push resin master

install_requirements:
	pip install -r requirements.txt

install_requirements_test:
	pip install -r requirements_test.txt

develop: remember
	python setup.py develop

install: remember
	python setup.py install

uninstall:
	pip uninstall -y botlib

reinstall: uninstall install

remember:
	@echo
	@echo "Hello from the Makefile..."
	@echo "Don't forget to run: 'make install_requirements'"
	@echo

remember_test:
	@echo
	@echo "Hello from the Makefile..."
	@echo "Don't forget to run: 'make install_requirements_test'"
	@echo

clean:
	@rm -rf *.egg* build dist *.py[oc] */*.py[co] cover doctest_pypi.cfg \
		nosetests.xml pylint.log output.xml flake8.log tests.log \
		test-result.xml htmlcov fab.log .coverage

pytest: remember_test
	pytest

pep8: remember_test
	flake8 --max-complexity 12 --exit-zero *.py botlib/*.py tests/*.py

flake8: pep8

lint: remember_test
	pylint --msg-template="{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}" \
		-r n *.py botlib/*.py tests/*.py || exit 0

pylint: lint

test: lint pep8 pytest

docker_install_requirements:
	docker_install_requirements.sh

docker_build:
	docker build --build-arg github_token=${GITHUB_TOKEN} .

checkmetadata:
	python setup.py check -s --restructuredtext

push_dev:
	balena push packet-pi

push_balena:
	@echo
	@echo "Don't forget to set GITHUB_TOKEN in your environment!"
	@echo
	echo $GITHUB_TOKEN > .balena/secrets/github_token
	balena push egoi-radio-bridge-access
