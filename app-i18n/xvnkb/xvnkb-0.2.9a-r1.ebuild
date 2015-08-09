# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib toolchain-funcs

IUSE="spell xft"

DESCRIPTION="Vietnamese input keyboard for X"
SRC_URI="http://xvnkb.sourceforge.net/${P}.tar.bz2"
HOMEPAGE="http://xvnkb.sourceforge.net/"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
RDEPEND="x11-libs/libX11
	xft? ( x11-libs/libXft )"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	local myconf

	tc-export CC

	use spell || myconf="${myconf} --no-spellcheck"
	use xft || myconf="${myconf} --no-xft"

	# *not* autotools
	./configure \
		--use-extstroke ${myconf} \
		|| die "./configure failed"

	emake || die "emake failed"
}

src_install() {
	dobin xvnkb
	dobin tools/xvnkb_ctrl

	dolib xvnkb.so.${PV}
	dosym xvnkb.so.${PV} /usr/$(get_libdir)/xvnkb.so

	dodoc ChangeLog AUTHORS THANKS TODO README* doc/*
	docinto scripts; dodoc scripts/*
	docinto contrib; dodoc contrib/*
}

pkg_postinst() {
	elog "Remember to"
	elog "$ export LANG=en_US.UTF-8"
	elog "(or any other UTF-8 locale) and"
	elog "$ export LD_PRELOAD=${DESTTREE}/lib/xvnkb.so"
	elog "before starting X Window"
	elog "More documents are in /usr/share/doc/${PF}"
	ewarn "Programs with suid/sgid will have LD_PRELOAD cleared"
	ewarn "You have to unset suid/sgid to use with xvnkb"
}
