# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd shell-completion

DESCRIPTION="A reverse proxy that exposes a server behind a NAT or firewall to the internet"
HOMEPAGE="https://github.com/fatedier/frp"
SRC_URI="
	https://github.com/fatedier/frp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/gentoo-zh-drafts/frp/releases/download/v${PV}/${P}-vendor.tar.xz
"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~loong ~riscv"

IUSE="+client +server"
REQUIRED_USE="|| ( client server )"

BDEPEND=">=dev-lang/go-1.24"

_compile() {
	ego build -tags "${1}" "./cmd/${1}"

	# Generate completion files
	"./${1}" completion bash > "${S}/completion/${1}" || die
	"./${1}" completion fish > "${S}/completion/${1}.fish" || die
	"./${1}" completion zsh > "${S}/completion/_${1}" || die
}

_install() {
	# Install binary file
	dobin "${1}"

	# Install completion files
	dobashcomp "${S}/completion/${1}"
	dofishcomp "${S}/completion/${1}.fish"
	dozshcomp "${S}/completion/_${1}"

	# Install systemd services
	systemd_dounit "${FILESDIR}/${1}.service"
	systemd_newunit "${FILESDIR}/${1}_at_.service" "${1}@.service"

	# Install config files
	insinto "/etc/${PN}"
	newins "${S}/conf/${1}.toml" "${1}.toml.example"
	newins "${S}/conf/${1}_full_example.toml" "${1}_full.toml.example"
}

src_compile() {
	mkdir -pv completion || die
	use client && _compile frpc
	use server && _compile frps
}

src_install() {
	use client && _install frpc
	use server && _install frps
}
