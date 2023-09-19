# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Docker Registry 2 authentication server"
HOMEPAGE="https://github.com/cesanta/docker_auth"

SRC_URI="https://github.com/cesanta/docker_auth/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~williamh/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 LGPL-3 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-go/go-bindata"
COMMON_DEPEND="acct-group/docker_auth
	acct-user/docker_auth"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

RESTRICT=" test"
S="${S}/auth_server"

src_compile() {
	# see the upstream Makefile for how to generate the VERSION and
	# BUILD_ID values.
	emake \
		VERSION=2022022022 \
		BUILD_ID=20220220-221158/1.9.0@636c09af \
		build
}

src_install() {
	cd ..
	dobin auth_server/auth_server
	dodoc README.md docs/*
	insinto /usr/share/${PF}
	doins -r examples
	insinto /etc/docker_auth/
	newins examples/reference.yml config.yml.example
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotated ${PN}
	keepdir /var/log/docker_auth
	fowners ${PN}:${PN} /var/log/docker_auth
}
