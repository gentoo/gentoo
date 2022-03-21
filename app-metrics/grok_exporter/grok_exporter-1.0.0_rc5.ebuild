# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PV=${PV/_rc/.RC}
inherit go-module

DESCRIPTION="Unstructured log data exporter for Prometheus"
HOMEPAGE="https://github.com/fstab/Grok_exporter"
SRC_URI="https://github.com/fstab/grok_exporter/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/grok_exporter
	acct-user/grok_exporter"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/oniguruma-6.9.0"
RDEPEND="${COMMON_DEPEND}
	>=dev-libs/oniguruma-6.9.0:="

RESTRICT="strip"
S="${WORKDIR}/${PN}-${MY_PV}"

src_compile() {
	ego build .
}

src_install() {
	dobin ${PN}
	dodoc -r *.md example
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
keepdir /etc/"${PN}"
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
	elog "You need to create /etc/${PN}/${PN}.yml"
	elog "Please see /usr/share/doc/${PVR} for examples"
	fi
}
