# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python bindings for the libao library"
HOMEPAGE="http://www.andrewchatham.com/pyogg/"
SRC_URI="http://www.andrewchatham.com/pyogg/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc -sparc x86"
IUSE=""

DEPEND=">=media-libs/libao-1.0.0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-new_api.patch )

python_compile() {
	"${PYTHON}" config_unix.py || die
	distutils-r1_python_compile
}
