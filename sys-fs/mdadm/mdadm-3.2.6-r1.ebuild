# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit multilib eutils flag-o-matic systemd toolchain-funcs

DESCRIPTION="A useful tool for running RAID systems - it can be used as a replacement for the raidtools"
HOMEPAGE="http://neil.brown.name/blog/mdadm"
SRC_URI="mirror://kernel/linux/utils/raid/mdadm/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="static"

DEPEND="virtual/pkgconfig"
RDEPEND="!<sys-apps/baselayout-2.1-r1
	!<sys-apps/openrc-0.10
	>=sys-apps/util-linux-2.16"

# The tests edit values in /proc and run tests on software raid devices.
# Thus, they shouldn't be run on systems with active software RAID devices.
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.2.1-mdassemble.patch #211426
	epatch "${FILESDIR}"/${PN}-3.2.x-udevdir.patch #430900
}

mdadm_emake() {
	emake \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		CC="$(tc-getCC)" \
		CWFLAGS="-Wall" \
		CXFLAGS="${CFLAGS}" \
		MAP_DIR=/run/mdadm \
		"$@"
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
	emake DESTDIR="${D}" install
	into /
	dosbin mdassemble
	dodoc ChangeLog INSTALL TODO README* ANNOUNCE-${PV}

	insinto /etc
	newins mdadm.conf-example mdadm.conf
	newinitd "${FILESDIR}"/mdadm.rc mdadm
	newconfd "${FILESDIR}"/mdadm.confd mdadm
	newinitd "${FILESDIR}"/mdraid.rc mdraid
	newconfd "${FILESDIR}"/mdraid.confd mdraid
	systemd_dounit "${FILESDIR}/mdadm.service"
	systemd_newtmpfilesd "${FILESDIR}/mdadm.tmpfiles.conf" mdadm.conf
}

pkg_preinst() {
	if ! has_version ${CATEGORY}/${PN} ; then
		# Only inform people the first time they install.
		elog "If you're not relying on kernel auto-detect of your RAID"
		elog "devices, you need to add 'mdraid' to your 'boot' runlevel:"
		elog "	rc-update add mdraid boot"
	fi
}
