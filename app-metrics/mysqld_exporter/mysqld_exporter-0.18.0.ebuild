# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver go-module

DESCRIPTION="Prometheus exporter for MySQL server metrics"
HOMEPAGE="https://github.com/prometheus/mysqld_exporter"
SRC_URI="https://github.com/prometheus/mysqld_exporter/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/mysqld_exporter
	acct-user/mysqld_exporter
"
RDEPEND="${DEPEND}"

src_compile() {
	mkdir -p bin || die

	local go_ldflags=(
		-X github.com/prometheus/common/version.Version=${PV}
		-X github.com/prometheus/common/version.Revision=${GIT_COMMIT}
		-X github.com/prometheus/common/version.Branch=master
		-X github.com/prometheus/common/version.BuildUser=gentoo
		-X github.com/prometheus/common/version.BuildDate="$(date +%F-%T)"
	)
	ego build -mod=vendor -ldflags "${go_ldflags[*]}" -o bin/${PN} .
	./bin/"${PN}" --help-man > "${PN}".1 || die
}

src_test() {
	emake test-flags= test
}

src_install() {
	dobin bin/*
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	doman "${PN}".1

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
		elog "Create \"${EROOT}/var/lib/mysqld_exporter/.my.cnf\" to read MySQL credentials from file."
	elif ver_replacing -lt "0.11.0"; then
		elog "Starting with ${PN}-0.11.0, command-line flags will require double dashes (--)."
		elog "You must update your configuration or ${PN} won't start."
	fi
}
