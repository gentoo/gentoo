# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user systemd

KEYWORDS="~amd64"
DESCRIPTION="Highly-available key value store for shared configuration and service discovery"
HOMEPAGE="https://github.com/coreos/etcd/"
SRC_URI="https://github.com/coreos/etcd/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc"
DEPEND=">=dev-lang/go-1.4:="
RDEPEND="!dev-db/etcdctl"

#pkg_setup() {
#	enewgroup ${PN}
#	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
#}

src_prepare() {
	sed -e 's|GIT_SHA=.*|GIT_SHA=v${PV}|'\
		-e 's|-ldflags "-s.*"|-v -x|' \
		-e 's|-ldflags "-s|-v -x "|' \
		-i build || die
	sed -e 's|go test|\0 -v|'\
		-i test || die
}

src_compile() {
	./build || die
}

src_install() {
	insinto /etc/${PN}
	doins "${FILESDIR}/${PN}.conf"
	dobin bin/*
	dodoc README.md
	use doc && dodoc -r Documentation
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles.d.conf" ${PN}.conf
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	dodir /var/lib/${PN}
	fowners ${PN}:${PN} /var/lib/${PN}
	fperms 755 /var/lib/${PN}
	dodir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	fperms 755 /var/log/${PN}
}

src_test() {
	./test || die
}
