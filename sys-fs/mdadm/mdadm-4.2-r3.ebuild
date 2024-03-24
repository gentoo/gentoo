# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic systemd toolchain-funcs udev

DESCRIPTION="Tool for running RAID systems - replacement for the raidtools"
HOMEPAGE="https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/"
DEB_PF="4.2~rc2-7"
SRC_URI="https://www.kernel.org/pub/linux/utils/raid/mdadm/${P/_/-}.tar.xz
		mirror://debian/pool/main/m/mdadm/${PN}_${DEB_PF}.debian.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ "${PV}" = *_rc* ]] || \
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="static systemd +udev"

REQUIRED_USE="static? ( !udev )"

BDEPEND="app-arch/xz-utils
	virtual/pkgconfig"
DEPEND="udev? ( virtual/libudev:= )"
RDEPEND="${DEPEND}
	>=sys-apps/util-linux-2.16"

# The tests edit values in /proc and run tests on software raid devices.
# Thus, they shouldn't be run on systems with active software RAID devices.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}"-3.4-sysmacros.patch #580188
	"${FILESDIR}/${PN}"-4.2-in_initrd-collision.patch #830461
	"${FILESDIR}/${PN}"-4.2-mdadm_env.patch #628968
)

mdadm_emake() {
	# We should probably make corosync & libdlm into USE flags. #573782
	local args=(
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
		CC="$(tc-getCC)"
		CWFLAGS="-Wall"
		CXFLAGS="${CFLAGS}"
		UDEVDIR="$(get_udevdir)"
		SYSTEMD_DIR="$(systemd_get_systemunitdir)"
		COROSYNC="-DNO_COROSYNC"
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
