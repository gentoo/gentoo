# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils flag-o-matic multilib systemd toolchain-funcs udev

DESCRIPTION="A useful tool for running RAID systems - it can be used as a replacement for the raidtools"
HOMEPAGE="http://neil.brown.name/blog/mdadm"
DEB_PR=2
SRC_URI="mirror://kernel/linux/utils/raid/mdadm/${P}.tar.xz
		mirror://debian/pool/main/m/mdadm/${PN}_3.3-${DEB_PR}.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="static"

DEPEND="virtual/pkgconfig
	app-arch/xz-utils"
RDEPEND=">=sys-apps/util-linux-2.16"

# The tests edit values in /proc and run tests on software raid devices.
# Thus, they shouldn't be run on systems with active software RAID devices.
RESTRICT="test"

mdadm_emake() {
	emake \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		CC="$(tc-getCC)" \
		CWFLAGS="-Wall" \
		CXFLAGS="${CFLAGS}" \
		UDEVDIR="$(get_udevdir)" \
		SYSTEMD_DIR="$(systemd_get_unitdir)" \
		"$@"
}

src_prepare() {
	# These are important bugfixes from upstream git after 3.3.1 release,
	# and before and including 17 Jul 2014:
	epatch \
		"${FILESDIR}"/${P}-Makefile-install-mdadm-grow-continue-.service.patch \
		"${FILESDIR}"/${P}-Grow-fix-removal-of-line-in-wrong-case.patch \
		"${FILESDIR}"/${P}-IMSM-use-strcpy-rather-than-pointless-strncpy.patch \
		"${FILESDIR}"/${P}-mdmon-ensure-Unix-domain-socket-is-created-with-safe.patch \
		"${FILESDIR}"/${P}-mdmon-allow-prepare_update-to-report-failure.patch \
		"${FILESDIR}"/${P}-DDF-validate-metadata_update-size-before-using-it.patch \
		"${FILESDIR}"/${P}-IMSM-validate-metadata_update-size-before-using-it.patch \
		"${FILESDIR}"/${P}-Grow-Do-not-try-to-restart-if-reshape-is-running.patch
}

src_compile() {
	use static && append-ldflags -static
	mdadm_emake all mdassemble
}

src_test() {
	mdadm_emake test

	sh ./test || die
}

src_install() {
	# Use split lines because of bug #517218
	mdadm_emake DESTDIR="${D}" install
	mdadm_emake DESTDIR="${D}" install-systemd
	into /
	dosbin mdassemble
	dodoc ChangeLog INSTALL TODO README* ANNOUNCE-${PV}

	insinto /etc
	newins mdadm.conf-example mdadm.conf
	newinitd "${FILESDIR}"/mdadm.rc mdadm
	newconfd "${FILESDIR}"/mdadm.confd mdadm
	newinitd "${FILESDIR}"/mdraid.rc mdraid
	newconfd "${FILESDIR}"/mdraid.confd mdraid

	# From the Debian patchset
	into /usr
	dodoc "${WORKDIR}"/debian/README.checkarray
	dosbin "${WORKDIR}"/debian/checkarray

	insinto /etc/cron.weekly
	newins "${FILESDIR}"/mdadm.weekly mdadm
}

pkg_postinst() {
	if ! systemd_is_booted; then
		if [[ -z ${REPLACING_VERSIONS} ]] ; then
			# Only inform people the first time they install.
			elog "If you're not relying on kernel auto-detect of your RAID"
			elog "devices, you need to add 'mdraid' to your 'boot' runlevel:"
			elog "	rc-update add mdraid boot"
		fi
	fi
}
