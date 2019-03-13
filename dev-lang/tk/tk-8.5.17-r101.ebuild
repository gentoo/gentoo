# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic multilib prefix toolchain-funcs versionator virtualx

MY_P="${PN}${PV/_beta/b}"

DESCRIPTION="Tk Widget Set"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="
	mirror://sourceforge/tcl/${MY_P}-src.tar.gz
	mirror://sourceforge/tcl/${MY_P//tk/tcl}-src.tar.gz
	"

LICENSE="tcltk"
SLOT="8.5"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug threads truetype aqua xscreensaver"

RDEPEND="
	!aqua? (
		media-libs/fontconfig
		media-libs/freetype:2
		x11-libs/libX11
		x11-libs/libXt
		truetype? ( x11-libs/libXft )
		xscreensaver? ( x11-libs/libXScrnSaver )
	)
	~dev-lang/tcl-${PV}:8.5=
	!=dev-lang/tk-8.5:0"
DEPEND="${RDEPEND}
	!aqua? ( x11-base/xorg-proto )"

SPARENT="${WORKDIR}/${MY_P}"
S="${SPARENT}"/unix

DOCS=()

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-8.5.11-fedora-xft.patch \
		"${FILESDIR}"/${PN}-8.5.13-multilib.patch

	epatch "${FILESDIR}"/${PN}-8.4.15-aqua.patch
	eprefixify Makefile.in

	# Bug 125971
	epatch "${FILESDIR}"/${PN}-8.5.14-conf.patch

	# Bug 648570
	epatch "${FILESDIR}"/${PN}-8.6.8-libieee.patch

	# Make sure we use the right pkg-config, and link against fontconfig
	# (since the code base uses Fc* functions).
	sed \
		-e 's/FT_New_Face/XftFontOpen/g' \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		-e 's:xft freetype2:xft freetype2 fontconfig:' \
		-i configure.in || die
	rm -f configure || die

	append-cppflags \
		-I"${WORKDIR}/${MY_P//tk/tcl}/generic" \
		-I"${WORKDIR}/${MY_P//tk/tcl}/unix"

	sed \
		-e '/chmod/s:555:755:g' \
		-i Makefile.in || die

	tc-export CC

	eautoconf
}

src_configure() {
	local v1=$(get_version_component_range 1-2)
	local mylibdir=$(get_libdir)

	econf \
		--with-tcl="${EPREFIX}/usr/${mylibdir}/tcl${v1}" \
		$(use_enable threads) \
		$(use_enable aqua) \
		$(use_enable truetype xft) \
		$(use_enable xscreensaver xss) \
		$(use_enable debug symbols)
}

src_test() {
	Xemake test
}

src_install() {
	dolib.so libtk8.5.so
}
