# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="the spiffe runtime environment"
HOMEPAGE="https://github.com/spiffe/spire"
SRC_URI="https://github.com/spiffe/spire/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/spire
	acct-user/spire"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	local targets v
	targets=(
		bin/spire-server
		bin/spire-agent
		bin/k8s-workload-registrar
		bin/oidc-discovery-provider
	)
	v=$(go version | cut -d ' ' -f 3) || die
	v=${v#go}
	emake go_version_full="${v}" "${targets[@]}"
}

src_test() {
	go test ./... || die "tests failed"
}

src_install() {
	exeinto /opt/spire
	doexe bin/*
	keepdir /opt/spire/.data
	insinto /etc/spire
	doins -r conf/*
	dosym ../../etc/spire /opt/spire/conf
	dosym ../../opt/spire/spire-agent /usr/bin/spire-agent
	dosym ../../opt/spire/spire-server /usr/bin/spire-server
	newconfd "${FILESDIR}"/spire-agent.confd spire-agent
	newinitd "${FILESDIR}"/spire-agent.initd spire-agent
	newconfd "${FILESDIR}"/spire-server.confd spire-server
	newinitd "${FILESDIR}"/spire-server.initd spire-server
	keepdir /var/log/spire
	fowners spire:spire /opt/spire/.data
	fowners spire:spire /var/log/spire
}
