# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit user systemd golang-vcs-snapshot

KEYWORDS="~amd64"
EGO_PN=github.com/coreos/etcd/...
DESCRIPTION="A highly-available key value store for shared configuration and service discovery"
HOMEPAGE="https://${EGO_PN%/*}/"
SRC_URI="https://${EGO_PN%/*}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc"
DEPEND=">=dev-lang/go-1.6:="
RDEPEND="!dev-db/etcdctl"


src_prepare() {
	eapply_user
	sed -e 's|GIT_SHA=.*|GIT_SHA=v${PV}|'\
		-i "${S}"/src/${EGO_PN%/*}/build || die
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

src_compile() {
	export GOPATH=${S}
	cd "${S}"/src/${EGO_PN%/*} || die
	./build || die
}

src_install() {
	cd "${S}"/src/${EGO_PN%/*} || die
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
	cd "${S}"/src/${EGO_PN%/*} || die
	./test || die
}
