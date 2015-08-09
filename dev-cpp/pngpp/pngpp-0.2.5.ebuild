# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_P=${P/pp/++}

DESCRIPTION="A simple but powerful C++ interface to libpng"
HOMEPAGE="http://www.nongnu.org/pngpp/"
SRC_URI="mirror://nongnu/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/libpng-1.2:0"
DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() { :; }
src_test() { :; }

src_install() {
	emake PREFIX="${D}/usr" install-headers
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	docinto examples
	dodoc example/*.cpp
}
