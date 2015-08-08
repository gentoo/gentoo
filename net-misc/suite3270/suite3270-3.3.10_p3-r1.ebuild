# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_PV=${PV/_p/ga}
MY_P=${PN}-${MY_PV}
SUB_PV=${PV:0:3}

S=${WORKDIR}

# only the x3270 package installs fonts
FONT_PN="x3270"
FONT_S=${WORKDIR}/${FONT_PN}-${SUB_PV}

inherit eutils font

DESCRIPTION="Complete 3270 access package"
HOMEPAGE="http://x3270.bgp.nu/"
SRC_URI="mirror://sourceforge/x3270/${MY_P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc s390 sparc x86"
IUSE="cjk doc ncurses ssl tcl X"

RDEPEND="ssl? ( dev-libs/openssl )
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libXt
	)
	ncurses? ( sys-libs/ncurses sys-libs/readline )
	tcl? ( dev-lang/tcl )"
DEPEND="${RDEPEND}
	X? (
		x11-misc/imake
		x11-misc/xbitmaps
		x11-proto/xproto
		app-text/rman
		x11-apps/mkfontdir
		x11-apps/bdftopcf
	)"

suite3270_makelist() {
	echo pr3287 s3270
	use ncurses && echo c3270
	use tcl && echo tcl3270
	use X && echo x3270
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	use X && ! use cjk && epatch "${FILESDIR}"/${P}-fix-x3270-dbcs.patch
}

src_compile() {
	local p
	for p in $(suite3270_makelist) ; do
		cd "${S}/${p}-${SUB_PV}"
		econf \
			--cache-file="${S}"/config.cache \
			$(use_enable cjk dbcs) \
			$(use_enable ssl) \
			$(use_with X x) \
			$(use_with X fontdir "${FONTDIR}") \
			|| die
		emake || die
	done
}

src_install() {
	use X && dodir "${FONTDIR}"
	local p
	for p in $(suite3270_makelist) ; do
		cd "${S}/${p}-${SUB_PV}"
		emake DESTDIR="${D}" install install.man || die
		docinto ${p}
		local d=$(echo README*)
		[[ -n ${d} ]] && dodoc ${d}
		use doc && dohtml html/*
	done
	chmod a-x "${D}"/usr/share/man/*/*

	use X && font_src_install
}

pkg_postinst() { use X && font_pkg_postinst ; }
pkg_postrm() { use X && font_pkg_postrm ; }
