# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Vulnerability Static Analysis for Containers"
HOMEPAGE="https://github.com/quay/clair"
SRC_URI="https://github.com/coreos/clair/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="acct-group/clair
	acct-user/clair"
	DEPEND="${COMMON_DEPEND}"
RDEPEND="app-arch/rpm
	app-arch/xz-utils
	dev-vcs/git
	${COMMON_DEPEND}
	!!sci-visualization/xd3d" # File collision (Bug #621044)

src_compile() {
	go build -o bin/${PN} ./cmd/${PN}  || die
	go build -o bin/clairctl ./cmd/clairctl  || die
}

src_install() {
	dobin bin/*
	keepdir /etc/clair
	dodoc -r Documentation/* {CHANGELOG,README,ROADMAP}.md
	insinto /usr/share/${PN}
	doins -r contrib config.yaml.sample

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
}

pkg_postinst() {
	[[ -f "${ROOT}"/etc/clair/clair.conf ]] && return
	ewarn "Please create ${ROOT}/etc/clair/config.yaml to use clair."
	ewarn "An example is in ${ROOT}/usr/share/clair/config.yaml.sample"
}
