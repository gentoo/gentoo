# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit base pam eutils

DESCRIPTION="The Console Display Manager"
HOMEPAGE="https://wiki.archlinux.org/index.php/CDM"
SRC_URI="http://dev.gentoo.org/~gienah/snapshots/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pam consolekit"
REQUIRED_USE="consolekit? ( pam )"

DEPEND="app-shells/bash"

RDEPEND="${DEPEND}
	dev-util/dialog
	x11-apps/xdpyinfo
	x11-apps/xinit
	consolekit? ( sys-auth/consolekit
		sys-apps/dbus )
	pam? ( virtual/pam )"

PATCHES=("${FILESDIR}/${PN}-0.5.3-invalid-MIT-cookie.patch")

src_prepare() {
	base_src_prepare
	if ! use consolekit; then
		sed -e 's@consolekit=yes@consolekit=no@' \
			-i "${S}/src/cdmrc" || die "Could not turn off consolekit in cdmrc"
	fi
}

src_install() {
	if use pam ; then
		pamd_mimic system-local-login cdm auth account session
	fi

	insinto /usr/bin/
	insopts -m0755
	dobin src/${PN}

	insinto /etc
	insopts -Dm644
	doins src/cdmrc

	insinto /usr/share/${PN}
	insopts -m644
	doins src/xinitrc*

	insinto /etc/profile.d/
	insopts -Dm755
	doins src/zzz-${PN}-profile.sh

	# Install themes
	insinto /usr/share/${PN}/themes
	doins src/themes/*
	# Copy documentation manually
	dodoc CHANGELOG
}

pkg_postinst() {
	einfo "In order to use CDM you must first edit your /etc/cdmrc"
	einfo "At least these should be edited before you start using CDM:"
	einfo "wmbinlist=(awesome openbox-session startkde startxfce4 gnome-session)"
	einfo "wmdisplist=(Awesome Openbox KDE Xfce Gnome)"
	einfo "Add whatever WM/DE you have."
	einfo "Then just login with your username"
	ewarn "Remove xdm from default runlevel"
}
