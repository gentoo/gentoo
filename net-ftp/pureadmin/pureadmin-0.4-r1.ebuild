# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pureadmin/pureadmin-0.4-r1.ebuild,v 1.5 2012/06/21 11:25:00 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="GUI tool used to make the management of Pure-FTPd a little easier"
HOMEPAGE="http://purify.sourceforge.net/"
SRC_URI="mirror://sourceforge/purify/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug doc"

RDEPEND="
	gnome-base/libglade:2.0
	sys-libs/zlib
	virtual/fam
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	cat >> po/POTFILES.skip <<- EOF
	src/eggstatusicon.c
	src/eggtrayicon.c
	src/prereq_usrmanager.c
	EOF
	epatch "${FILESDIR}"/${P}-gold.patch
}

src_configure() {
	local myconf=""

	use debug && myconf="${myconf} --enable-debug"

	econf ${myconf}
}

src_install() {
	default

	# Move the docs to the correct location, if we want the docs
	if use doc ; then
		dodoc "${ED}"usr/share/pureadmin/docs/*
	fi
	rm -Rfv "${ED}"usr/share/pureadmin/docs || die

	make_desktop_entry pureadmin "Pure-FTPd menu config" pureadmin
}

pkg_postinst() {
	ewarn "PureAdmin is at a beta-stage right now and it may break your"
	ewarn "configuration. DO NOT use it for safety critical system"
	ewarn "or production use!"
	echo
	elog "You need root-privileges to be able to use PureAdmin."
	elog "This will probably change in the future."
	echo
}
