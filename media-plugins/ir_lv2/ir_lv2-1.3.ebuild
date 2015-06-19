# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/ir_lv2/ir_lv2-1.3.ebuild,v 1.3 2015/03/17 12:08:54 aballier Exp $

EAPI=3

inherit toolchain-funcs flag-o-matic multilib

MY_P="${P/_/.}"
DESCRIPTION="LV2 convolver plugin especially for creating reverb effects"
HOMEPAGE="http://factorial.hu/plugins/lv2/ir"
SRC_URI="http://factorial.hu/system/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="media-libs/zita-convolver
	>=x11-libs/gtk+-2.16:2
	media-libs/lv2
	media-libs/libsndfile
	media-libs/libsamplerate"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN/_/.}

src_prepare() {
	sed -i -e 's/g++/$(CXX)/' -e 's/gcc/$(CC)/' Makefile || die #respect CC/CXX
	sed -i -e 's/\(^C4CFLAGS =.*\) -O2.*/\1 $(CFLAGS)/' Makefile || die #respect CFLAGS
	sed -i -e 's/\(^CPPFLAGS +=.*\) -O2.*/\1 $(CXXFLAGS)/' Makefile || die #respect CXXFLAGS
}

src_compile() {
	tc-export CC CXX
	emake || die
}

src_install() {
	emake INSTDIR="${D}/usr/$(get_libdir)/lv2/ir.lv2" install || die
	dodoc README ChangeLog || die
}
