# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit udev optfeature python-single-r1

DESCRIPTION="Optimize laptop battery life"
HOMEPAGE="https://linrunner.de/tlp/"
SRC_URI="https://github.com/linrunner/TLP/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/TLP-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="pd? ( ${PYTHON_REQUIRED_USE} )"

IUSE="
	+pd
	+rdw
"

RDEPEND="
	dev-lang/perl
	virtual/udev
	sys-apps/hdparm
	net-wireless/iw
	!app-laptop/laptop-mode-tools
	sys-apps/pciutils
	!sys-apps/tuned
	sys-apps/usbutils
	pd? ( dev-python/dbus-python )
	pd? ( !sys-power/power-profiles-daemon )
	pd? ( dev-python/pygobject )
	pd? ( ${PYTHON_DEPS} )
	pd? ( !sys-apps/tuned )
	rdw? ( net-misc/networkmanager )
"
DEPEND="${RDEPEND}"

src_install() {
	# NOTE(JayF): TLP_WITH_ELOGIND/TLP_WITH_SYSTEMD are both only installing
	#             small init/config files.
	local myemakeargs=(
		DESTDIR="${D}"
		TLP_NO_INIT=1
		TLP_WITH_ELOGIND=1
		TLP_WITH_SYSTEMD=1
		install-tlp install-man-tlp
	)

	use pd && myemakeargs+=(
		install-pd
		install-man-pd
	)

	use rdw && myemakeargs+=(
		install-rdw
		install-man-rdw
	)

	emake "${myemakeargs[@]}"

	fperms 444 /usr/share/tlp/defaults.conf # manpage says this file should not be edited
	newinitd "${FILESDIR}/tlp.init" tlp
	newinitd "${FILESDIR}/tlp-pd.init" tlp-pd
	keepdir /var/lib/tlp # created by Makefile, probably important
}

pkg_postinst() {
	udev_reload

	optfeature "disable Wake-on-LAN" sys-apps/ethtool
	optfeature "see disk drive health info in tlp-stat" sys-apps/smartmontools
	optfeature "Sleep hooks" sys-auth/elogind sys-apps/systemd
	optfeature "Battery functions for ThinkPads prior to the Sandy Bridge generation (2011)" app-laptop/tp_smapi
}

pkg_postrm() {
	udev_reload
}
