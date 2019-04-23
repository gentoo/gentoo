# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils toolchain-funcs

DESCRIPTION="A wave viewer for LXT, LXT2, VZT, GHW and standard Verilog VCD/EVCD files"
HOMEPAGE="http://gtkwave.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

IUSE="doc examples fasttree fatlines judy lzma packed tcl"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"

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

AT_M4DIR="${S}"

src_prepare(){
	# do not install doc and examples by default
	sed -i -e 's/doc examples//' Makefile.in || die
	default
}

src_configure(){
	econf --disable-local-libz \
		--disable-local-libbz2 \
		--disable-mime-update \
		--enable-largefile \
		$(use_enable packed struct-pack) \
		$(use_enable fatlines) \
		$(use_enable tcl) \
		$(use_enable lzma xz) \
		$(use_enable fasttree) \
		$(use_enable judy)
}

src_compile() {
	emake AR=$(tc-getAR)
}

src_install() {
	emake DESTDIR="${ED}" install
	dodoc ChangeLog README
	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins "doc/${PN}.odt"
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
