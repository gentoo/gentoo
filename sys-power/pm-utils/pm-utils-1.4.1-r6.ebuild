# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib

DESCRIPTION="Suspend and hibernation utilities"
HOMEPAGE="https://pm-utils.freedesktop.org/"
SRC_URI="https://pm-utils.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86"
IUSE="alsa debug ntp video_cards_intel video_cards_radeon"

vbetool="!video_cards_intel? ( sys-apps/vbetool )"
RDEPEND="!<app-laptop/laptop-mode-tools-1.55-r1
	!sys-power/powermgmt-base[-pm-utils(+)]
	sys-apps/dbus
	>=sys-apps/util-linux-2.13
	sys-power/pm-quirks
	alsa? ( media-sound/alsa-utils )
	ntp? ( || ( net-misc/ntp net-misc/openntpd ) )
	amd64? ( ${vbetool} )
	x86? ( ${vbetool} )
	video_cards_radeon? ( app-laptop/radeontool )"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS pm/HOWTO* README* TODO"

src_prepare() {
	local ignore="01grub"
	use ntp || ignore+=" 90clock"

	use debug && echo 'PM_DEBUG="true"' > "${T}"/gentoo
	echo "HOOK_BLACKLIST=\"${ignore}\"" >> "${T}"/gentoo

	epatch \
		"${FILESDIR}"/${PV}-bluetooth-sync.patch \
		"${FILESDIR}"/${PV}-disable-sata-alpm.patch \
		"${FILESDIR}"/${PV}-fix-intel-audio-powersave-hook.patch \
		"${FILESDIR}"/${PV}-logging-append.patch \
		"${FILESDIR}"/${PV}-fix-alpm-typo.patch \
		"${FILESDIR}"/${PV}-inhibit-on-right-status.patch \
		"${FILESDIR}"/${PV}-ignore-led-failure.patch \
		"${FILESDIR}"/${PV}-run-hook-logging.patch \
		"${FILESDIR}"/${PV}-suspend-hybrid.patch \
		"${FILESDIR}"/${PV}-uswsusp-hibernate-mode.patch \
		"${FILESDIR}"/${PV}-xfs_buffer_arguments.patch
}

src_configure() {
	econf --disable-doc
}

src_install() {
	default
	doman man/*.{1,8}

	# Remove duplicate documentation install
	rm -r "${ED}"/usr/share/doc/${PN}

	insinto /etc/pm/config.d
	doins "${T}"/gentoo

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN} #408091

	exeinto /usr/$(get_libdir)/${PN}/sleep.d
	doexe "${FILESDIR}"/sleep.d/50unload_alx

	exeinto /usr/$(get_libdir)/${PN}/power.d
	doexe "${FILESDIR}"/power.d/{pci_devices,usb_bluetooth}

	# No longer required with current networkmanager (rm -f from debian/rules)
	rm -f "${ED}"/usr/$(get_libdir)/${PN}/sleep.d/55NetworkManager

	# No longer required with current kernels (rm -f from debian/rules)
	rm -f "${ED}"/usr/$(get_libdir)/${PN}/sleep.d/49bluetooth

	# Punt HAL related file wrt #401257 (rm -f from debian/rules)
	rm -f "${ED}"/usr/$(get_libdir)/${PN}/power.d/hal-cd-polling

	# Punt hooks which have shown to not reduce, or even increase power usage
	# (rm -f from debian rules)
	rm -f "${ED}"/usr/$(get_libdir)/${PN}/power.d/{journal-commit,readahead}

	# Remove hooks which are not stable enough yet (rm -f from debian/rules)
	rm -f "${ED}"/usr/$(get_libdir)/${PN}/power.d/harddrive

	# Change to executable (chmod +x from debian/rules)
	fperms +x /usr/$(get_libdir)/${PN}/defaults
}
