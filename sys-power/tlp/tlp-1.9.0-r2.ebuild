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
REQUIRED_USE="ppd? ( ${PYTHON_REQUIRED_USE} )"

IUSE="
	+ppd
	+rdw
"

# NOTE(JayF): Upstream dep list in human-readable format:
#             https://linrunner.de/tlp/developers/dependencies.html
# NOTE(JayF): Blockers for these are not ideal, however all three
#             of these packages implement the same service on dbus
#             and have conflicting files as a result. Long-term
#             there likely needs to be a better solution. See
#             https://bugs.gentoo.org/967823.
RDEPEND="
	dev-lang/perl
	net-wireless/iw
	sys-apps/hdparm
	sys-apps/pciutils
	sys-apps/usbutils
	virtual/udev
	ppd? (
		!sys-apps/tuned[ppd]
		!sys-power/power-profiles-daemon
		$(python_gen_cond_dep 'dev-python/dbus-python[${PYTHON_USEDEP}]')
		$(python_gen_cond_dep 'dev-python/pygobject[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)
	rdw? ( net-misc/networkmanager )
"
DEPEND="${RDEPEND}"
DOCS=( changelog README.rst )

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

	use ppd && myemakeargs+=(
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
	einstalldocs
}

pkg_postinst() {
	udev_reload

	optfeature "disable Wake-on-LAN" sys-apps/ethtool
	optfeature "see disk drive health info in tlp-stat" sys-apps/smartmontools
	optfeature "Sleep hooks" sys-auth/elogind sys-apps/systemd
	optfeature "Battery functions for ThinkPads prior to the Sandy Bridge generation (2011)" app-laptop/tp_smapi

	if has_version "sys-apps/tuned"; then
		ewarn
		ewarn "sys-apps/tuned is installed, but is "
		ewarn "documented by upstream sys-power/tlp to be conficting. "
		ewarn "For best results, uninstall one of these packages."
		ewarn
	fi

	if has_version "app-laptop/laptop-mode-tools"; then
		ewarn
		ewarn "app-laptop/laptop-mode-tools is installed, but is "
		ewarn "documented by upstream sys-power/tlp to be conficting. "
		ewarn "For best results, uninstall one of these packages."
		ewarn
	fi
}

pkg_postrm() {
	udev_reload
}
