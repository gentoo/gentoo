# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module
# uncomment the first setting of MY_PV for a normal release
# MY_PV="v${PV/_rc/-rc.}"
# set MY_PV to the full commit hash for a snapshot release
MY_PV=f5d5289f7627016d8b53b0b3fa7615da8a73b56a
MYSQLD_EXPORTER_COMMIT=f5d5289f

DESCRIPTION="Prometheus exporter for MySQL server metrics"
HOMEPAGE="https://github.com/prometheus/mysqld_exporter"
SRC_URI="https://github.com/prometheus/mysqld_exporter/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="dev-util/promu"

DEPEND="acct-group/mysqld_exporter
	acct-user/mysqld_exporter"

RDEPEND="${DEPEND}"

# Comment this for a normal release.
S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( "${FILESDIR}"/${PN}-0.12.1-skip-tests.patch )

src_prepare() {
	default

	sed -i -e "s/{{.Revision}}/${MYSQLD_EXPORTER_COMMIT}/" .promu.yml || die
}

src_compile() {
	mkdir -p bin || die

	promu build --prefix bin || die

	# comment this for a normal release.
	mv bin/${PN}-${MY_PV} bin/${PN} || die
}

src_install() {
	dobin bin/*
	dodoc {README,CHANGELOG,CONTRIBUTING}.md

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
