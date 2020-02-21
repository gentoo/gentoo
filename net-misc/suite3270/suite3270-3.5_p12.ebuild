# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_PV=${PV/_p/ga}
MY_P=${PN}-${MY_PV}
SUB_PV=${PV:0:3}

S=${WORKDIR}/${PN}-${SUB_PV}

# only the x3270 package installs fonts
FONT_PN="x3270"
FONT_S="${S}/${FONT_PN}"

inherit eutils font

DESCRIPTION="Complete 3270 access package"
HOMEPAGE="http://x3270.bgp.nu/"
SRC_URI="mirror://sourceforge/x3270/${MY_P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc s390 sparc x86"
IUSE="cjk doc ncurses ssl tcl X"

RDEPEND="ssl? ( dev-libs/openssl:0= )
	X? (
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libXt
	)
	ncurses? (
		sys-libs/ncurses:=
		sys-libs/readline:0=
	)
	tcl? ( dev-lang/tcl:0 )"
DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-misc/xbitmaps
		app-text/rman
		>=x11-apps/mkfontscale-1.2.0
		x11-apps/bdftopcf
	)"

suite3270_makelist() {
	echo pr3287 s3270 \
		$(usex ncurses c3270 '') \
		$(usex tcl tcl3270 '') \
		$(usex X x3270 '')
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.5_p8-tinfo.patch

	# Some subdirs (like c3270/x3270/s3270) install the same set of data files
	# (they have the same contents).  Wrap that in a retry to avoid errors.
	cat <<-EOF > _install
	#!/bin/sh
	for n in 1 2 3 4 5; do
		install "\$@" && exit
		echo "retrying ..."
	done
	exit 1
	EOF
	chmod a+rx _install
	# Can't use the $INSTALL var as top level configure also uses it.
	# https://sourceforge.net/p/x3270/bugs/15/
	export ac_cv_path_install="${S}/_install"
}

src_configure() {
	echo "${INSTALL}"
	econf \
		--cache-file="${S}"/config.cache \
		--enable-s3270 \
		--enable-pr3287 \
		$(use_enable ncurses c3270) \
		$(use_enable tcl tcl3270) \
		$(use_enable X x3270) \
		$(use_with X x) \
		$(use_with X fontdir "${FONTDIR}")
}

src_install() {
	use X && dodir "${FONTDIR}"
	emake DESTDIR="${D}" install{,.man}

	local p
	for p in $(suite3270_makelist) ; do
		cd "${S}/${p}"
		docinto ${p}
		dodoc README*
		use doc && dohtml html/*
	done

	use X && font_src_install
}

pkg_postinst() { use X && font_pkg_postinst ; }
pkg_postrm() { use X && font_pkg_postrm ; }
