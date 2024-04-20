# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

KEYWORDS="~amd64"
EGO_PN="github.com/hashicorp/serf"
DESCRIPTION="Service orchestration and management tool"
HOMEPAGE="https://www.serfdom.io/"
SRC_URI="https://github.com/hashicorp/serf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

SLOT="0"
LICENSE="MPL-2.0 Apache-2.0 BSD MIT"
IUSE=""
RESTRICT+=" test"
BDEPEND=""
RDEPEND="
	acct-user/serf
	acct-group/serf"

src_prepare() {
	default
	sed -e 's|\(^VERSION[[:space:]]*:=\).*|\1'${PV}'|' \
		-e 's|\(GITSHA[[:space:]]*:=\).*|\1'${PV}'|' \
		-e 's|\(GITBRANCH[[:space:]]*:=\).*|\1'${PV}'|' \
		-i  GNUmakefile || die
}

src_compile() {
	mkdir -p ./bin
	go build -o ./bin/serf ./cmd/serf || die
}

src_install() {
	local x

	dobin "${S}/bin/${PN}"

	keepdir /etc/serf.d
	insinto /etc/serf.d

	for x in /var/{lib,log}/${PN}; do
		keepdir "${x}"
		fowners serf:serf "${x}"
	done

	newinitd "${FILESDIR}/serf.initd" "${PN}"
	newconfd "${FILESDIR}/serf.confd" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/serf.service"
}
