# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Python wrapper for libmad MP3 decoding in python"
HOMEPAGE="
	https://github.com/jaqx0r/pymad/
	https://pypi.org/project/pymad/
"
SRC_URI="
	https://github.com/jaqx0r/${PN}/archive/version/${PV}.tar.gz
		-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-version-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"

DEPEND="media-libs/libmad"
RDEPEND="${DEPEND}"
