# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit pam eutils

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

src_prepare() {
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
	dobin src/${PN} src/${PN}-xlaunch

	insinto /etc
	insopts -Dm644
	doins src/cdmrc

	insinto /etc/profile.d/
	insopts -Dm755
	newins src/profile.sh zzz-${PN}.sh

	# Install themes
	insinto /usr/share/${PN}/themes
	doins themes/*
	# Copy documentation manually
	dodoc ChangeLog-0.6 ChangeLog-before-0.6 README.md
}

pkg_postinst() {
	ewarn "In order to use CDM you must first edit your /etc/cdmrc"
	ewarn "At least the binlist, namelist and flaglist entries should be added or edited"
	ewarn "to specify the X window managers and console shells that you want before"
	ewarn "you start CDM.  Something like:"
	ewarn "binlist=('xmonad' 'startkde' '/bin/zsh --login' '/bin/bash --login')"
	ewarn "namelist=('XMonad' 'KDE' 'Console Zsh' 'Console Bash')"
	ewarn "flaglist=(X X C C)"
	ewarn "Ensure the flaglist X entries correspond to the X-Windows programs, and the"
	ewarn "C entries correspond to console shells.  Then just login with your username."
	ewarn "Remove xdm from default runlevel."
}
