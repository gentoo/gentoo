# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eapi7-ver user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/mysqld_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
MYSQLD_EXPORTER_COMMIT="8068006"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for MySQL server metrics"
HOMEPAGE="https://github.com/prometheus/mysqld_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-util/promu"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/mysqld_exporter ${PN}
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${MYSQLD_EXPORTER_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GOPATH="${S}" promu build -v --prefix bin || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/mysqld_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	popd || die

	keepdir /var/lib/mysqld_exporter /var/log/mysqld_exporter
	fowners ${PN}:${PN} /var/lib/mysqld_exporter /var/log/mysqld_exporter
	fperms 0770 /var/lib/mysqld_exporter

	newinitd "${FILESDIR}"/${PN}-r1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-r1.confd ${PN}

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "Create \"${EROOT%/}/var/lib/mysqld_exporter/.my.cnf\" to read MySQL credentials from file."
	else
		local _replacing_version=
		for _replacing_version in ${REPLACING_VERSIONS}; do
			if ! ver_test "${_replacing_version}" -ge "0.11.0"; then
				elog "Starting with ${PN}-0.11.0, command-line flags will require double dashes (--)."
				elog "You must update your configuration or ${PN} won't start."

				break
			fi
		done
	fi
}
