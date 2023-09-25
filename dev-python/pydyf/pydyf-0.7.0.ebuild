# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A low-level PDF generator"
HOMEPAGE="
	https://pypi.org/project/pydyf/
	https://github.com/CourtBouillon/pydyf/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	test? (
		app-text/ghostscript-gpl
		dev-python/pillow[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
