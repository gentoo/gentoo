# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo check-reqs readme.gentoo-r1 systemd tmpfiles

DESCRIPTION="Unofficial Bitwarden compatible password manager"
HOMEPAGE="https://github.com/dani-garcia/vaultwarden"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dani-garcia/vaultwarden.git"
else
	SRC_URI="
	https://github.com/dani-garcia/vaultwarden/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rahilarious/gentoo-distfiles/releases/download/${P}/deps.tar.xz -> ${P}-deps.tar.xz
	https://github.com/rahilarious/gentoo-distfiles/releases/download/${P}/wiki.tar.xz -> ${P}-docs.tar.xz
"
	KEYWORDS="~amd64"
fi

LICENSE="AGPL-3"
# Dependent crate licenses
LICENSE+=" 0BSD Apache-2.0 BSD ISC MIT MPL-2.0 Unicode-3.0"

SLOT="0"
IUSE="cli mysql postgres +sqlite +web"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="
	acct-user/vaultwarden
	acct-group/vaultwarden
	dev-libs/openssl:=
	cli? ( app-admin/bitwarden-cli-bin )
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )
	web? ( www-apps/vaultwarden-web )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

QA_FLAGS_IGNORED="usr/bin/${PN}"
QA_PRESTRIPPED="usr/bin/${PN}"
ECARGO_VENDOR="${WORKDIR}/vendor"

PATCHES=(
	"${FILESDIR}"/vaultwarden-envfile-1.34.1.patch
)

CHECKREQS_MEMORY=3G
CHECKREQS_DISK_BUILD=2G

DOC_CONTENTS="\n
	Configuration file: /etc/${PN}/${PN}.conf\n
	Data directory: /var/lib/${PN}\n
	Log file: /var/log/${PN}.log\n
	Default endpoint: http://127.0.0.1:8000\n
	Admin endpoint: http://127.0.0.1:8000/admin\n
	\n
	MySQL & PostgreSQL users must set DATABASE_URL in config\n
"

pkg_setup() {
	check-reqs_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
		# clone vaultwarden
		git-r3_src_unpack

		# clone vaultwarden.wiki
		EGIT_REPO_URI="https://github.com/dani-garcia/vaultwarden.wiki.git"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}.wiki"
		git-r3_src_unpack

		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	if use !web; then
		sed -i \
			-e 's|^# WEB_VAULT_ENABLED=true|WEB_VAULT_ENABLED=false|g;' \
			.env.template || die
	fi

	if use mysql || use postgres; then
		declare -a DB_UNIT
		use mysql && DB_UNIT+=(
				mariadb.service
				mysqld.service
			)
		use postgres && DB_UNIT+=(
				postgresql-{13..17}.service
			)
		cat <<-EOF > "${T}/${PN}-db.conf"
			[Unit]
			After=${DB_UNIT[@]}
			Wants=${DB_UNIT[@]}
		EOF
	fi

}

src_configure() {
	local myfeatures=(
		$(usev sqlite)
		$(usev mysql)
		$(usev postgres postgresql )
	)
	cargo_src_configure
}

src_compile() {
	# https://github.com/dani-garcia/vaultwarden/blob/main/build.rs
	[[ ${PV} != 9999* ]] && export VW_VERSION="${PV}"
	cargo_src_compile
}

src_install() {
	dobin "$(cargo_target_dir)/${PN}"
	systemd_newunit "${FILESDIR}"/vaultwarden-1.33.2.service \
					"${PN}".service
	if [[ -f "${T}/${PN}-db.conf" ]]; then
		local UNIT_DIR="$(systemd_get_systemunitdir)"
		insinto "${UNIT_DIR#${EPREFIX}}/${PN}".service.d
		doins "${T}/${PN}-db.conf"
	fi
	newinitd "${FILESDIR}"/vaultwarden-1.33.2.initd "${PN}"
	newconfd "${FILESDIR}"/vaultwarden-1.33.2.confd "${PN}"
	newtmpfiles "${FILESDIR}"/vaultwarden-tmpfiles-1.33.2.conf "${PN}".conf
	insinto /etc/logrotate.d
	newins "${FILESDIR}/"vaultwarden-1.33.2.logrotated "${PN}"
	insinto /etc/"${PN}"
	newins .env.template "${PN}".conf
	keepdir /var/lib/"${PN}"
	fowners "${PN}":"${PN}" /var/lib/"${PN}"
	fperms 750 /var/lib/"${PN}"

	readme.gentoo_create_doc
	einstalldocs
	dodoc -r ../"${PN}".wiki/*
}

pkg_postinst() {
	tmpfiles_process "${PN}".conf
	readme.gentoo_print_elog
}
