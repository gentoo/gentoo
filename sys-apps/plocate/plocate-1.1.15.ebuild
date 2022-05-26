# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info meson systemd

DESCRIPTION="Posting locate is a much faster locate"
HOMEPAGE="https://plocate.sesse.net/"
SRC_URI="https://plocate.sesse.net/download/${P}.tar.gz"

# GPL-2 for updatedb
# GPL-2+ for plocate itself
LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="+io-uring"

RDEPEND="
	acct-group/locate
	app-arch/zstd:=
	io-uring? ( sys-libs/liburing:= )
	!sys-apps/mlocate
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.15-meson-use-feature-option-for-libiouring.patch
)

pkg_setup() {
	if use io-uring && linux_config_exists; then
		if ! linux_chkconfig_present IO_URING; then
			ewarn "CONFIG_IO_URING must be enabled for USE=io-uring"
		fi
	fi
}

src_prepare() {
	# We'll install the manpage ourself to locate.1
	sed -i "/install_man('plocate.1')/d" meson.build || die

	default
}

src_configure() {
	local emesonargs=(
		-Dlocategroup=locate
		-Dinstall_systemd=true
		-Dinstall_cron=false
		-Dsystemunitdir="$(systemd_get_systemunitdir)"
		"$(meson_feature io-uring use_libiouring)"
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc README NEWS
	newman "${S}"/${PN}.1 locate.1
	dosym plocate /usr/bin/locate

	insinto /etc
	doins "${FILESDIR}"/updatedb.conf
	doins "${FILESDIR}"/plocate-cron.conf
	fperms 0644 /etc/{updatedb,plocate-cron}.conf

	insinto /etc/cron.daily
	# Ensure that the cron file has the same name as the
	# systemd-timer, to avoid plocate being run twice daily on systems
	# with a systemd compatiblity layer. See also bug #780351.
	newins "${FILESDIR}"/plocate.cron plocate-updatedb
	fperms 0755 /etc/cron.daily/plocate-updatedb

	systemd_dounit "${BUILD_DIR}"/${PN}-updatedb.service "${S}"/${PN}-updatedb.timer
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]] ; then
		elog "The database for the locate command is generated daily by a cron job,"
		elog "if you install for the first time you can run the updatedb command manually now."
		elog
		elog "Note that the ${EROOT}/etc/updatedb.conf file is generic,"
		elog "please customize it to your system requirements."
	fi
}
