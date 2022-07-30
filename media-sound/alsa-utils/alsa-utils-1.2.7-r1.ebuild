# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit systemd udev

DESCRIPTION="Advanced Linux Sound Architecture Utils (alsactl, alsamixer, etc.)"
HOMEPAGE="https://alsa-project.org/wiki/Main_Page"
SRC_URI="https://www.alsa-project.org/files/pub/utils/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0.9"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ~ppc64 ~riscv sparc ~x86"
IUSE="bat doc +libsamplerate ieee1394 +ncurses nls selinux"

CDEPEND=">=media-libs/alsa-lib-${PV}
	libsamplerate? ( media-libs/libsamplerate )
	ieee1394? ( media-libs/libffado )
	ncurses? ( >=sys-libs/ncurses-5.7-r7:0= )
	bat? ( sci-libs/fftw:= )"
DEPEND="${CDEPEND}
	doc? ( app-text/xmlto )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-alsa )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.8-missing_header.patch
)

src_configure() {
	export ac_cv_lib_ffado_ffado_streaming_init=$(usex ieee1394)

	local myeconfargs=(
		# --disable-alsaconf because it doesn't work with sys-apps/kmod wrt #456214
		--disable-alsaconf
		--disable-maintainer-mode
		--with-asound-state-dir="${EPREFIX}"/var/lib/alsa
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		--with-udev-rules-dir="${EPREFIX}/$(get_udevdir)"/rules.d
		$(use_enable bat)
		$(use_enable libsamplerate alsaloop)
		$(use_enable ncurses alsamixer)
		$(use_enable nls)
		$(usex doc '' --disable-xmlto)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc seq/*/README.*

	newinitd "${FILESDIR}"/alsasound.initd-r8 alsasound
	newconfd "${FILESDIR}"/alsasound.confd-r4 alsasound

	insinto /etc/modprobe.d
	newins "${FILESDIR}"/alsa-modules.conf-rc alsa.conf

	keepdir /var/lib/alsa

	# ALSA lib parser.c:1266:(uc_mgr_scan_master_configs) error: could not
	# scan directory /usr/share/alsa/ucm: No such file or directory
	# alsaucm: unable to obtain card list: No such file or directory
	keepdir /usr/share/alsa/ucm
}

pkg_postinst() {
	udev_reload

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog
		elog "To take advantage of the init script, and automate the process of"
		elog "saving and restoring sound-card mixer levels you should"
		elog "add alsasound to the boot runlevel. You can do this as"
		elog "root like so:"
		elog "# rc-update add alsasound boot"
		ewarn
		ewarn "The ALSA core should be built into the kernel or loaded through other"
		ewarn "means. There is no longer any modular auto(un)loading in alsa-utils."
	fi
}

pkg_postrm() {
	udev_reload
}
