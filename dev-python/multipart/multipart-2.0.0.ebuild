# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="Parser for multipart/form-data"
HOMEPAGE="
	https://github.com/defnull/multipart/
	https://pypi.org/project/multipart/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
