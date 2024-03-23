# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd shell-completion

DESCRIPTION="A reverse proxy that exposes a server behind a NAT or firewall to the internet"
HOMEPAGE="https://github.com/fatedier/frp"
SRC_URI="https://github.com/fatedier/frp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~riscv"
IUSE="+client +server"
REQUIRED_USE="|| ( client server )"

DEPEND="${RDEPEND}"
RDEPEND=""
BDEPEND="dev-lang/go"

src_compile() {
	mkdir -pv completions || die

	if use client; then
		ego build -trimpath -ldflags "-w" -o frpc ./cmd/frpc
		./frpc completion bash > completions/frpc || die
		./frpc completion fish > completions/frpc.fish || die
		./frpc completion zsh > completions/_frpc || die
	fi

	if use server; then
		ego build -trimpath -ldflags "-w" -o frps ./cmd/frps
		./frps completion bash > completions/frps || die
		./frps completion fish > completions/frps.fish || die
		./frps completion zsh > completions/_frps || die
	fi
}

src_install() {
	if use client; then
		dobin frpc
		dobashcomp completions/frpc
		systemd_dounit "${FILESDIR}/frpc.service"
		systemd_newunit "${FILESDIR}/frpc_at_.service" frpc@.service

		for x in conf/frpc*.toml; do mv "${x}"{,.example}; done
	fi

	if use server; then
		dobin frps
		dobashcomp completions/frps
		systemd_dounit "${FILESDIR}/frps.service"
		systemd_newunit "${FILESDIR}/frps_at_.service" frps@.service

		for x in conf/frps*.toml; do mv "${x}"{,.example}; done
	fi

	insinto /etc/frp
	doins conf/*.example

	dofishcomp completions/*.fish
	dozshcomp completions/_*
}
