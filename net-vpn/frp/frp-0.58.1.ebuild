# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd shell-completion

DESCRIPTION="A reverse proxy that exposes a server behind a NAT or firewall to the internet"
HOMEPAGE="https://github.com/fatedier/frp"
SRC_URI="https://github.com/fatedier/frp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv"
IUSE="+client +server"
REQUIRED_USE="|| ( client server )"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	mkdir -pv comp || die

	if use client; then
		ego build -trimpath -ldflags "-s -w" -tags frpc -o frpc ./cmd/frpc
		./frpc completion bash > comp/frpc || die
		./frpc completion fish > comp/frpc.fish || die
		./frpc completion zsh > comp/_frpc || die
	fi

	if use server; then
		ego build -trimpath -ldflags "-s -w" -tags frps -o frps ./cmd/frps
		./frps completion bash > comp/frps || die
		./frps completion fish > comp/frps.fish || die
		./frps completion zsh > comp/_frps || die
	fi
}

src_install() {
	_install() {
		# Install binary file
		dobin "${1}"

		# Install completion files
		dobashcomp "${S}/comp/${1}"
		dofishcomp "${S}/comp/${1}.fish"
		dozshcomp "${S}/comp/_${1}"

		# Install systemd services
		systemd_dounit "${FILESDIR}/${1}.service"
		systemd_newunit "${FILESDIR}/${1}_at_.service" "${1}@.service"

		# Install config files
		insinto "/etc/${PN}"
		newins "${S}/conf/${1}.toml" "${1}.toml.example"
		newins "${S}/conf/${1}_full_example.toml" "${1}_full.toml.example"
	}

	if use client; then
		_install frpc
	fi

	if use server; then
		_install frps
	fi
}
