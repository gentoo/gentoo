# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Vietnamese input keyboard for X"
SRC_URI="http://xvnkb.sourceforge.net/${P}.tar.bz2"
HOMEPAGE="http://xvnkb.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="spell xft"

RDEPEND="
	x11-libs/libX11:=
	xft? ( x11-libs/libXft:= )"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"

PATCHES=( "${FILESDIR}"/${P}-ldflags.patch )

src_configure() {
	tc-export CC

	local myconf=()
	! use spell && myconf+=( --no-spellcheck )
	! use xft && myconf+=( --no-xft )

	# *not* autotools
	./configure \
		--use-extstroke "${myconf[@]}" \
		|| die "./configure failed"
}

src_install() {
	dobin xvnkb
	dobin tools/xvnkb_ctrl

	dolib.so xvnkb.so.${PV}
	dosym xvnkb.so.${PV} /usr/$(get_libdir)/xvnkb.so

	einstalldocs
	dodoc -r doc/. scripts contrib
}

pkg_postinst() {
	elog "Remember to"
	elog "$ export LANG=en_US.UTF-8"
	elog "(or any other UTF-8 locale) and"
	elog "$ export LD_PRELOAD=/usr/$(get_libdir)/xvnkb.so"
	elog "before starting X Window"
	elog "More documents are in ${EROOT}/usr/share/doc/${PF}"

	ewarn "Programs with suid/sgid will have LD_PRELOAD cleared"
	ewarn "You have to unset suid/sgid to use with xvnkb"
}
