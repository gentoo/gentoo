# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion go-module readme.gentoo-r1 systemd

DESCRIPTION="Reverse proxy that provides authentication with many identity providers"
HOMEPAGE="
	https://oauth2-proxy.github.io/oauth2-proxy/
	https://github.com/oauth2-proxy/oauth2-proxy
"
SRC_URI="https://github.com/oauth2-proxy/oauth2-proxy/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="MIT"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC Unlicense"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/nobody
	acct-user/nobody
"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.26.0"

src_compile() {
	local -x CGO_ENABLED=0
	local go_ldflags=(
		-X github.com/oauth2-proxy/oauth2-proxy/v7/pkg/version.VERSION=${PV}
	)
	ego build -ldflags "${go_ldflags[*]}" -o bin/${PN} .
}

src_test() {
	ego test ./...
}

src_install() {
	dobin bin/${PN}
	einstalldocs
	dodoc contrib/oauth2-proxy.cfg.example
	newbashcomp contrib/${PN}_autocomplete.sh ${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_newunit "${FILESDIR}"/${PN}_at.service ${PN}@.service

	keepdir /etc/${PN}
	fperms 0750 /etc/${PN}
	fowners root:nobody /etc/${PN}

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
