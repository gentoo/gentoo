# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic systemd toolchain-funcs udev

DESCRIPTION="Tool for running RAID systems - replacement for the raidtools"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/"
DEB_PF="4.3-1"
SRC_URI="https://www.kernel.org/pub/linux/utils/raid/mdadm/${P/_/-}.tar.xz
		mirror://debian/pool/main/m/mdadm/${PN}_${DEB_PF}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ "${PV}" = *_rc* ]] || \
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv sparc x86"
IUSE="static systemd +udev corosync"

REQUIRED_USE="static? ( !udev )"

BDEPEND="virtual/pkgconfig"
DEPEND="udev? ( virtual/libudev:= )
	corosync? ( sys-cluster/corosync )"
RDEPEND="${DEPEND}
	>=sys-apps/util-linux-2.16"

# The tests edit values in /proc and run tests on software raid devices.
# Thus, they shouldn't be run on systems with active software RAID devices.
RESTRICT="test"

PATCHES=(
	#"${FILESDIR}/${PN}"-3.4-sysmacros.patch #580188 # upstream has it later in the list of includes as of 4.3.
	"${FILESDIR}/${PN}"-4.3-in_initrd-collision.patch #830461
	"${FILESDIR}/${PN}"-4.2-mdadm_env.patch #628968
	"${FILESDIR}/${PN}"-4.3-ldflags.patch
	"${FILESDIR}/${PN}"-4.3-no-udev.patch
	"${FILESDIR}/${PN}"-4.3-musl125-1.patch
	"${FILESDIR}/${PN}"-4.3-do-not-call-gcc-directly.patch # 931972
	"${FILESDIR}/${PN}"-4.3-musl-basename.patch
	"${FILESDIR}/${PN}"-4.3-musl-include.patch
	"${WORKDIR}/debian/patches/debian/0001-fix-manpages.patch"
	"${WORKDIR}/debian/patches/debian/0003-host-name-in-default-mailfrom.patch"
	"${WORKDIR}/debian/patches/debian/0004-exit-gracefully-when-md-device-not-found.patch"
	"${WORKDIR}/debian/patches/debian/0007-no-Werror.patch"
)

mdadm_emake() {
	# We should probably make libdlm into USE flags. #573782
	local args=(
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		CC="$(tc-getCC)"
		CWFLAGS="-Wall -fPIE"
		CXFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		UDEVDIR="$(get_udevdir)"
		SYSTEMD_DIR="$(systemd_get_systemunitdir)"
		COROSYNC="$(usex corosync '' -DNO_COROSYNC)"
		DLM="-DNO_DLM"

		# https://bugs.gentoo.org/732276
		STRIP=

		"$@"
	)
	emake "${args[@]}"
}

src_compile() {
	use static && append-ldflags -static

	# CPPFLAGS won't work for this
	use udev || append-cflags -DNO_LIBUDEV

	# bug 907082
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	mdadm_emake all
}

src_test() {
	mdadm_emake test

	sh ./test || die
}

src_install() {
	mdadm_emake DESTDIR="${D}" install install-systemd
	dodoc ChangeLog INSTALL TODO README* ANNOUNCE-*

	# install mdcheck_start.service
	# needed for systemd units https://bugs.gentoo.org/833000
	exeinto /usr/share/mdadm/
	doexe misc/mdcheck

	insinto /etc
	newins mdadm.conf-example mdadm.conf
	newinitd "${FILESDIR}"/mdadm.rc mdadm
	newconfd "${FILESDIR}"/mdadm.confd mdadm
	newinitd "${FILESDIR}"/mdraid.rc mdraid
	newconfd "${FILESDIR}"/mdraid.confd mdraid

	# From the Debian patchset
	into /usr
	dodoc "${WORKDIR}"/debian/local/doc/README.checkarray
	dosbin "${WORKDIR}"/debian/local/bin/checkarray
	insinto /etc/default
	newins "${FILESDIR}"/etc-default-mdadm mdadm

	exeinto /etc/cron.weekly
	newexe "${FILESDIR}"/mdadm.weekly mdadm
}

pkg_postinst() {
	udev_reload
	if ! systemd_is_booted; then
		if [[ -z ${REPLACING_VERSIONS} ]] ; then
			# Only inform people the first time they install.
			elog "If you're not relying on kernel auto-detect of your RAID"
			elog "devices, you need to add 'mdraid' to your 'boot' runlevel:"
			elog "	rc-update add mdraid boot"
		fi
	fi
}

pkg_postrm() {
	udev_reload
}
