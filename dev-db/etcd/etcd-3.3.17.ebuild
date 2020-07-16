# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user systemd golang-vcs-snapshot

KEYWORDS="amd64"
EGO_PN="github.com/coreos/etcd"
GIT_COMMIT="6d80523"
MY_PV="${PV/_rc/-rc.}"
DESCRIPTION="Highly-available key value store for shared configuration and service discovery"
HOMEPAGE="https://github.com/etcd-io/etcd"
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
IUSE="doc +server"
DEPEND=">=dev-lang/go-1.12:="
RDEPEND="!dev-db/etcdctl"

src_prepare() {
	default
	sed -e "s|GIT_SHA=.*|GIT_SHA=${GIT_COMMIT}|"\
		-i "${S}"/src/${EGO_PN}/build || die
	sed -e 's:\(for p in \)shellcheck :\1 :' \
		-e 's:^			gofmt \\$:\\:' \
		-e 's:^			govet \\$:\\:' \
		-i "${S}"/src/${EGO_PN}/test || die
	# missing ... in args forwarded to print-like function
	sed -e 's:l\.Logger\.Panic(v):l.Logger.Panic(v...):' \
		-i "${S}"/src/${EGO_PN}/raft/logger.go || die
}

pkg_setup() {
	if use server; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	fi
}

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME #651934
	export GOPATH=${S}
	pushd src/${EGO_PN} || die
	GO_BUILD_FLAGS=-v ./build || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin bin/etcdctl
	use doc && dodoc -r Documentation
	if use server; then
		insinto /etc/${PN}
		doins "${FILESDIR}/${PN}.conf"
		dobin bin/etcd
		dodoc README.md
		systemd_dounit "${FILESDIR}/${PN}.service"
		systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles.d.conf" ${PN}.conf
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotated" "${PN}"
		keepdir /var/lib/${PN}
		fowners ${PN}:${PN} /var/lib/${PN}
		fperms 0700 /var/lib/${PN}
		keepdir /var/log/${PN}
		fowners ${PN}:${PN} /var/log/${PN}
		fperms 755 /var/log/${PN}
	fi
	popd || die
}

src_test() {
	pushd src/${EGO_PN} || die
	./test || die
	popd || die
}
