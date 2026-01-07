# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Gentoo GLEP support for docutils"
HOMEPAGE="
	https://github.com/projg2/docutils-glep/
	https://pypi.org/project/docutils-glep/
"
SRC_URI="
	https://github.com/projg2/docutils-glep/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/docutils-0.10[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
