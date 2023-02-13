# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A low-level PDF generator"
HOMEPAGE="
	https://pypi.org/project/pydyf/
	https://github.com/CourtBouillon/pydyf/
"
SRC_URI="
	https://github.com/CourtBouillon/pydyf/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
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
