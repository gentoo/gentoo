# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyopenal/pyopenal-0.1.6-r1.ebuild,v 1.5 2015/06/06 16:47:09 floppym Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 flag-o-matic

MY_P="${P/pyopenal/PyOpenAL}"

DESCRIPTION="OpenAL library port for Python"
HOMEPAGE="http://home.gna.org/oomadness/en/pyopenal/"
SRC_URI="http://download.gna.org/pyopenal/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=dev-python/pyogg-1.1[${PYTHON_USEDEP}]
	>=dev-python/pyvorbis-1.1[${PYTHON_USEDEP}]
	media-libs/freealut
	media-libs/openal"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS CHANGES )
PATCHES=( "${FILESDIR}/${P}-setup.patch" )

python_compile() {
	local CFLAGS=${CFLAGS}
	append-cflags -fno-strict-aliasing
	distutils-r1_python_compile
}
