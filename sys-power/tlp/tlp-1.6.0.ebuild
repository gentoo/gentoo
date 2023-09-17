# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev optfeature

DESCRIPTION="Optimize laptop battery life"
HOMEPAGE="https://linrunner.de/tlp/"
SRC_URI="https://github.com/linrunner/TLP/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/TLP-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

# It's uncertain if elogind/systemd is actually required, however, without the sleep
# hooks working, which require one of them, it doesn't seem like this app is very useful.
RDEPEND="
	dev-lang/perl
	virtual/udev
	|| ( sys-auth/elogind sys-apps/systemd )
"

src_install() {
	emake \
		DESTDIR="${D}" \
		TLP_NO_INIT=1 \
		TLP_ELOD=/$(get_libdir)/elogind/system-sleep \
		TLP_WITH_ELOGIND=1 \
		TLP_WITH_SYSTEMD=1 \
		install install-man

	fperms 444 /usr/share/tlp/defaults.conf # manpage says this file should not be edited
	newinitd "${FILESDIR}/tlp.init" tlp
	keepdir /var/lib/tlp # created by Makefile, probably important
}

pkg_postinst() {
	udev_reload

	optfeature "disable Wake-on-LAN" sys-apps/ethtool
	optfeature "see disk drive health info in tlp-stat" sys-apps/smartmontools
}

pkg_postrm() {
	udev_reload
}
