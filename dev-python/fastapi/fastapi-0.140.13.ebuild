# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{14..15} )
#may be not stricly required
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 optfeature pypi

DESCRIPTION="High performance framework, easy to learn, fast to code, ready for production"
HOMEPAGE="
	https://fastapi.tiangolo.com/
	https://github.com/fastapi/fastapi/
	https://pypi.org/project/fastapi/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/annotated-doc-0.0.4[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.46.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.8.0[${PYTHON_USEDEP}]
	>=dev-python/typing-inspection-0.4.2[${PYTHON_USEDEP}]
"

#FIXME: add missing deps
BDEPEND="
	test? (
		dev-python/a2wsgi[${PYTHON_USEDEP}]
		dev-python/dirty-equals[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
		dev-python/httpx2[${PYTHON_USEDEP}]
		dev-python/pydantic-settings[${PYTHON_USEDEP}]
		dev-python/python-multipart[${PYTHON_USEDEP}]
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/typer[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio inline-snapshot pytest-timeout )
# 3k tests+, so use xdist to speed them up
EPYTEST_XDIST=1
distutils_enable_tests pytest

# There are some JSON response tests that will exercise orjson or ujson if they are available.
# These are properly skipped if the optional dependencies are not installed at the cost of a little spam.
python_test() {
	local EPYTEST_IGNORE=(
		# python/strawberry-graphql (in guru, test dep only)
		tests/test_tutorial/test_graphql/test_tutorial001.py
		# dev-python/sqlmodel (in guru, test dep only)
		tests/test_tutorial/test_sql_databases/test_tutorial001.py
		tests/test_tutorial/test_sql_databases/test_tutorial002.py
		# dev-python/fastapi-cli (missing, test and optfeature)
		tests/test_fastapi_cli.py
		# dev-python/pwdlib (in guru, test dep only)
		tests/test_tutorial/test_security/test_tutorial004.py
		tests/test_tutorial/test_security/test_tutorial005.py
		# Wants dev-python/multipart _just_ to complain that it's not the right multipart lib.
		tests/test_multipart_installation.py
		# scripts/tests use CliRunner.isolated_filesystem() removed in recent typer
		scripts/tests
	)
	local EPYTEST_DESELECT=(
		# Requires investigation - missing ./image.png test file (?)
		tests/test_tutorial/test_additional_responses/test_tutorial004.py::test_path_operation_img

		# Broken by brotli being available, also fragile to random ordering
		tests/test_tutorial/test_header_param_models/test_tutorial001.py::test_header_param_model_invalid
		tests/test_tutorial/test_header_param_models/test_tutorial003.py::test_header_param_model_invalid
		tests/test_tutorial/test_header_param_models/test_tutorial003.py::test_header_param_model_no_underscore
	)
	epytest
}

pkg_postinst() {
	# not part of any upstream extra
	optfeature "alternative JSON library" "dev-python/ujson" # orjson, too but it's deprecated

	# pyproject.toml:project.optional-dependencies.standard
	# Following optfeatures should be exposed, but missing deps
	#	optfeature "fastAPI CLI" "dev-python/fastapi-cli" - missing - depends on this package!
	#	optfeature "compressed file support" "dev-python/fastar" - missing
	#	optfeature "pydantic extra types support" "dev-python/pydantic-extra-types" - in guru
	optfeature_header "standard extras"
	optfeature "ASGI server support" "dev-python/uvicorn"
	optfeature "email validation support" "dev-python/email-validator"
	optfeature "TestClient for testing FastAPI applications" "dev-python/httpx"
	optfeature "templating support" "dev-python/jinja2"
	optfeature "multipart form data support" "dev-python/python-multipart"
	optfeature "settings management support" "dev-python/pydantic-settings"

	# pyproject.toml:project.optional-dependencies.all - includes all the above plus:
	optfeature_header "all extras"
	optfeature "session middleware support" "dev-python/itsdangerous"
	optfeature "YAML support" "dev-python/pyyaml"
}
