# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python Bindings for TagLib"
HOMEPAGE="
	https://github.com/palfrey/tagpy/
	https://pypi.org/project/tagpy/
"
SRC_URI="
	https://github.com/palfrey/tagpy/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"

DEPEND="
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	>=media-libs/taglib-1.8
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest
