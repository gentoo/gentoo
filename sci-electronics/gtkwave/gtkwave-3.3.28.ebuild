# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/gtkwave/gtkwave-3.3.28.ebuild,v 1.9 2015/03/20 15:27:56 jlec Exp $

EAPI="2"

DESCRIPTION="A wave viewer for LXT, LXT2, VZT, GHW and standard Verilog VCD/EVCD files"
HOMEPAGE="http://gtkwave.sourceforge.net/"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

IUSE="doc examples fasttree fatlines judy lzma tcl"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/pango
	sys-libs/zlib
	judy? ( dev-libs/judy )
	tcl? ( dev-lang/tcl:0 dev-lang/tk:0 )
	lzma? ( app-arch/xz-utils )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-util/gperf"

src_prepare(){
	sed -i -e 's/doc examples//' Makefile.in || die "sed failed"
}

src_configure(){
	econf --disable-local-libz \
		--disable-local-libbz2 \
		--disable-dependency-tracking \
		--enable-largefile \
		$(use_enable fatlines) \
		$(use_enable tcl) \
		$(use_enable lzma xz) \
		$(use_enable fasttree) \
		$(use_enable judy)
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc ANALOG_README.TXT SYSTEMVERILOG_README.TXT CHANGELOG.TXT
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "doc/${PN}.odt" || die "Failed to install documentation."
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "Failed to install examples."
	fi
}
