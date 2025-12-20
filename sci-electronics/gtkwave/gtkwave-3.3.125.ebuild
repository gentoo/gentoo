# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic gnome2-utils toolchain-funcs xdg

MY_P="${PN}-gtk3-${PV}"
DESCRIPTION="Wave viewer for LXT, LXT2, VZT, GHW and standard Verilog VCD/EVCD files"
HOMEPAGE="https://gtkwave.github.io/gtkwave/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="fasttree judy lzma tcl wayland X"

RDEPEND="
	app-arch/bzip2
	dev-libs/glib:2
	virtual/zlib:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	x11-libs/gtk+:3[wayland?,X?]
	judy? ( dev-libs/judy )
	tcl? (
		dev-lang/tcl:0=
		dev-lang/tk:0=
	)
	lzma? ( app-arch/xz-utils )
"
DEPEND="
	${RDEPEND}
	net-libs/libtirpc
"
BDEPEND="
	dev-util/gperf
	virtual/pkgconfig
"

PATCHES=(
	# https://github.com/gtkwave/gtkwave/pull/455
	"${FILESDIR}"/${PN}-3.3.125-fix_bashism.patch
	"${FILESDIR}"/${PN}-3.3.125-fix_c23.patch
	"${FILESDIR}"/${PN}-3.3.125-fix_musl.patch
)

src_prepare() {
	default

	# doc and examples are installed manually then in the right path
	sed -i -e 's/doc examples//' Makefile.in || die
}

src_configure() {
	# defang automagic dependencies
	use wayland || append-cppflags -DGENTOO_GTK_HIDE_WAYLAND
	use X || append-cppflags -DGENTOO_GTK_HIDE_X11

	export ac_cv_path_PKG_CONFIG="$(tc-getPKG_CONFIG)"
	local myeconfargs=(
		--disable-mime-update
		--disable-struct-pack # runtime error w/ UBSAN
		--enable-largefile
		--enable-gtk3
		--with-gsettings
		--with-tirpc
		$(use_enable tcl)
		$(use_enable lzma xz)
		$(use_enable fasttree)
		$(use_enable judy)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	# AR for tcl.m4
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	insinto /usr/share/metainfo
	doins share/appdata/io.github.gtkwave.GTKWave.metainfo.xml

	dodoc doc/${PN}.odt
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples /usr/share/doc/${PF}/${PN}.odt
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
