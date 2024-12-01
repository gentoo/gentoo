# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev optfeature

DESCRIPTION="Optimize laptop battery life"
HOMEPAGE="https://linrunner.de/tlp/"
SRC_URI="https://github.com/linrunner/TLP/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/TLP-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

# It's uncertain if elogind/systemd is actually required, however, without the sleep
# hooks working, which require one of them, it doesn't seem like this app is very useful.
RDEPEND="
	dev-lang/perl
	virtual/udev
	|| ( sys-auth/elogind sys-apps/systemd )
"

src_install() {
	# NOTE(JayF): TLP_WITH_ELOGIND/TLP_WITH_SYSTEMD are both only installing
	#             small init/config files.
	local myemakeargs=(
		DESTDIR="${D}"
		TLP_NO_INIT=1
		TLP_ELOD=/usr/lib/elogind/system-sleep
		TLP_WITH_ELOGIND=1
		TLP_WITH_SYSTEMD=1
		install install-man
	)
	emake "${myemakeargs[@]}"

	fperms 444 /usr/share/tlp/defaults.conf # manpage says this file should not be edited
	newinitd "${FILESDIR}/tlp.init" tlp
	keepdir /var/lib/tlp # created by Makefile, probably important

	# <elogind-255.5 used a different path (bug #939216), keep a compat symlink
	# TODO: cleanup after 255.5 been stable for a few months
	dosym {/usr/lib,/"$(get_libdir)"}/elogind/system-sleep/49-tlp-sleep
}

pkg_postinst() {
	udev_reload

	optfeature "disable Wake-on-LAN" sys-apps/ethtool
	optfeature "see disk drive health info in tlp-stat" sys-apps/smartmontools
}

pkg_postrm() {
	udev_reload
}
