# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

MY_PV=${PV/_p/ga}
MY_P=${PN}-${MY_PV}
SUB_PV=${PV:0:3}

S=${WORKDIR}

# only the x3270 package installs fonts
FONT_PN="x3270"
FONT_S=${WORKDIR}/${FONT_PN}-${SUB_PV}

inherit eutils font multiprocessing

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
	tcl? ( dev-lang/tcl:0 )"
DEPEND="${RDEPEND}
	X? (
		x11-misc/xbitmaps
		x11-proto/xproto
		app-text/rman
		x11-apps/mkfontdir
		x11-apps/bdftopcf
	)"

suite3270_makelist() {
	echo pr3287 s3270 \
		$(usex ncurses c3270 '') \
		$(usex tcl tcl3270 '') \
		$(usex X x3270 '')
}

src_prepare() {
	# Some subdirs (like c3270/x3270/s3270) install the same set of data files
	# (they have the same contents).  Wrap that in a retry to avoid errors.
	cat <<-EOF > _install
	#!/bin/sh
	for n in {1..5}; do
		install "\$@" && exit
		echo "retrying ..."
	done
	EOF
	chmod a+rx _install
	sed -i \
		-e "s:@INSTALL@:${S}/_install:" \
		*/Makefile.in
}

src_configure() {
	local p myconf
	# Run configures in parallel!
	multijob_init
	for p in $(suite3270_makelist) ; do
		cd "${S}/${p}-${SUB_PV}"
		if [[ ${p} == "x3270" ]] ; then
			myconf=(
				--without-xmkmf
				$(use_with X x)
				$(use_with X fontdir "${FONTDIR}")
			)
		else
			myconf=()
		fi
		multijob_child_init econf \
			--cache-file="${S}"/config.cache \
			$(use_enable cjk dbcs) \
			$(use_enable ssl) \
			"${myconf[@]}"
	done
	sed \
		-e "s:@SUBDIRS@:$(suite3270_makelist):" \
		-e "s:@VER@:${SUB_PV}:" \
		"${FILESDIR}"/Makefile.in > "${S}"/Makefile || die
	multijob_finish
}

src_install() {
	use X && dodir "${FONTDIR}"
	EXTRA_TARGETS='install.man' default
	local p
	for p in $(suite3270_makelist) ; do
		cd "${S}/${p}-${SUB_PV}"
		docinto ${p}
		local d=$(echo README*)
		[[ -n ${d} ]] && dodoc ${d}
		use doc && dohtml html/*
	done
	find "${ED}"/usr/share/man/ -type f -exec chmod a-x {} +

	use X && font_src_install
}

pkg_postinst() { use X && font_pkg_postinst ; }
pkg_postrm() { use X && font_pkg_postrm ; }
