# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python wrapper for libmad MP3 decoding in python"
HOMEPAGE="https://github.com/jaqx0r/pymad"
SRC_URI="https://github.com/jaqx0r/${PN}/archive/version/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-version-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="media-libs/libmad"
RDEPEND="${DEPEND}"
