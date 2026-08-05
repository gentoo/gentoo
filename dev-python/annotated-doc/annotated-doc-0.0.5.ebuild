# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Document parameters, variables inline, with Annotated"
HOMEPAGE="
	https://github.com/fastapi/annotated-doc/
	https://pypi.org/project/annotated-doc/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# not useful for us, requires dev-python/typer
	tests/test_prepare_release.py
)
