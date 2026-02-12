# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYPI_VERIFY_REPO=https://github.com/fastapi/annotated-doc
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Document parameters, variables inline, with Annotated"
HOMEPAGE="
	https://github.com/fastapi/annotated-doc/
	https://pypi.org/project/annotated-doc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
