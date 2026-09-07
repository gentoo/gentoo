# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.94.0"
CRATES=""
inherit cargo systemd

DESCRIPTION="Push daemon for Nextcloud clients"
HOMEPAGE="https://github.com/nextcloud/notify_push"
SRC_URI="https://github.com/nextcloud/notify_push/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/antonfischl1980/nextcloud-notify_push/releases/download/v${PV}/nextcloud-notify_push-${PV}-crates.tar.xz"
S=${WORKDIR}/notify_push-${PV}

LICENSE="AGPL-3"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD CDLA-Permissive-2.0 GPL-3 ISC MIT Unicode-3.0 ZLIB"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-db/sqlite:3"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	export LIBSQLITE3_SYS_USE_PKG_CONFIG=1
	default
}

src_install() {
	cargo_src_install
	einstalldocs

	# default name is too generic
	mv "${ED}/usr/bin/notify_push" "${ED}/usr/bin/${PN}" || die

	newconfd "${FILESDIR}/${PN}-r1.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}-r2.init" "${PN}"
	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"
	#systemd_install_serviced "${FILESDIR}/${PN}.service.conf" "${PN}"

	# restrict access because conf.d entry could contain
	# database credentials
	fperms 0640 "/etc/conf.d/${PN}"
}

pkg_postinst() {
	if has_version sys-apps/systemd; then
		elog "Configure nextcloud-notify_push before you start the service:"
		elog
		elog "systemctl edit --drop-in=nextcloud nextcloud-notify_push.service"
		elog
		elog "add a section [Service],  add the path to the nextcloud config file"
		elog "as well as the user and group your webserver runs as (apache, nginx)."
		elog
		elog "Exapmle:"
		elog "[Service]"
		elog 'Environment=NOTIFY_PUSH_NEXTCLOUD_CONFIGFILE="/var/www/cloud.example.com/htdocs/config/config.php'
		elog "User=apache"
		elog "Group=apache"
		elog
		elog "If you need options for the notify_push process, you can override ExecStart. Just add (adjust to your needs):"
		elog "ExecStart="
		elog "ExecStart=/usr/bin/nextcloud-notify_push $NOTIFY_PUSH_NEXTCLOUD_CONFIGFILE --bind 127.0.0.1 --nextcloud-url https://cloud.example.com"
	fi
}
