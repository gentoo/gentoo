# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Service orchestration and management tool"
HOMEPAGE="https://www.serfdom.io/"
SRC_URI="https://github.com/hashicorp/serf/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${PF}-deps.tar.xz"

LICENSE="MPL-2.0"
LICENSE+=" Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT+=" test"
RDEPEND="
	acct-user/serf
	acct-group/serf"
PATCHES=("${S}/go-mod-sum.patch")

src_prepare() {
	default
	sed -e 's|\(^VERSION[[:space:]]*:=\).*|\1'${PV}'|' \
		-e 's|\(GITSHA[[:space:]]*:=\).*|\1'${PV}'|' \
		-e 's|\(GITBRANCH[[:space:]]*:=\).*|\1'${PV}'|' \
		-i  GNUmakefile || die
}

src_compile() {
	mkdir -p ./bin
	ego build -o ./bin/serf ./cmd/serf || die
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
