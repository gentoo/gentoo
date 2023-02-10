#!/bin/bash
# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
source tests-common.sh || exit

inherit pypi

test-eq() {
	local call=${1}
	local exp=${2}

	tbegin "${call} -> ${exp}"
	local ret=0
	local have=$(${call})
	if [[ ${have} != ${exp} ]]; then
		eindent
		eerror "incorrect result: ${have}"
		eoutdent
		ret=1
	fi
	tend "${ret}"
}

test-eq "pypi_normalize_name foo" foo
test-eq "pypi_normalize_name foo_bar" foo_bar
test-eq "pypi_normalize_name foo___bar" foo_bar
test-eq "pypi_normalize_name Flask-BabelEx" flask_babelex
test-eq "pypi_normalize_name jaraco.context" jaraco_context

PN=Foo.Bar
PV=1.2.3

test-eq "pypi_wheel_name" foo_bar-1.2.3-py3-none-any.whl
test-eq "pypi_wheel_name Flask-BabelEx" flask_babelex-1.2.3-py3-none-any.whl
test-eq "pypi_wheel_name Flask-BabelEx 4" flask_babelex-4-py3-none-any.whl
test-eq "pypi_wheel_name Flask-BabelEx 4 py2.py3" \
	flask_babelex-4-py2.py3-none-any.whl
test-eq "pypi_wheel_name cryptography 39.0.1 cp36 abi3-manylinux_2_28_x86_64" \
	cryptography-39.0.1-cp36-abi3-manylinux_2_28_x86_64.whl

test-eq "pypi_wheel_url" \
	https://files.pythonhosted.org/packages/py3/F/Foo.Bar/foo_bar-1.2.3-py3-none-any.whl
test-eq "pypi_wheel_url Flask-BabelEx" \
	https://files.pythonhosted.org/packages/py3/F/Flask-BabelEx/flask_babelex-1.2.3-py3-none-any.whl
test-eq "pypi_wheel_url Flask-BabelEx 4" \
	https://files.pythonhosted.org/packages/py3/F/Flask-BabelEx/flask_babelex-4-py3-none-any.whl
test-eq "pypi_wheel_url Flask-BabelEx 4 py2.py3" \
	https://files.pythonhosted.org/packages/py2.py3/F/Flask-BabelEx/flask_babelex-4-py2.py3-none-any.whl
test-eq "pypi_wheel_url cryptography 39.0.1 cp36 abi3-manylinux_2_28_x86_64" \
	https://files.pythonhosted.org/packages/cp36/c/cryptography/cryptography-39.0.1-cp36-abi3-manylinux_2_28_x86_64.whl

test-eq "pypi_wheel_url --unpack" \
	"https://files.pythonhosted.org/packages/py3/F/Foo.Bar/foo_bar-1.2.3-py3-none-any.whl -> foo_bar-1.2.3-py3-none-any.whl.zip"
test-eq "pypi_wheel_url --unpack Flask-BabelEx" \
	"https://files.pythonhosted.org/packages/py3/F/Flask-BabelEx/flask_babelex-1.2.3-py3-none-any.whl -> flask_babelex-1.2.3-py3-none-any.whl.zip"
test-eq "pypi_wheel_url --unpack Flask-BabelEx 4" \
	"https://files.pythonhosted.org/packages/py3/F/Flask-BabelEx/flask_babelex-4-py3-none-any.whl -> flask_babelex-4-py3-none-any.whl.zip"
test-eq "pypi_wheel_url --unpack Flask-BabelEx 4 py2.py3" \
	"https://files.pythonhosted.org/packages/py2.py3/F/Flask-BabelEx/flask_babelex-4-py2.py3-none-any.whl -> flask_babelex-4-py2.py3-none-any.whl.zip"
test-eq "pypi_wheel_url --unpack cryptography 39.0.1 cp36 abi3-manylinux_2_28_x86_64" \
	"https://files.pythonhosted.org/packages/cp36/c/cryptography/cryptography-39.0.1-cp36-abi3-manylinux_2_28_x86_64.whl -> cryptography-39.0.1-cp36-abi3-manylinux_2_28_x86_64.whl.zip"

texit
