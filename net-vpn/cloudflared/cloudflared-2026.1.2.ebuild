# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A command-line client and tunneling daemon for Cloudflare Tunnel"
HOMEPAGE="https://github.com/cloudflare/cloudflared"
SRC_URI="https://github.com/cloudflare/cloudflared/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# "make test" fails since cloudflared-2024.12.1, and fails with network-sanbox
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.24.11"

src_compile(){
	local ldflags="
		-X main.Version=${PV}
		-X 'main.BuildTime=$(date +'%F %T %z')'"
	ego build -ldflags "${ldflags}" ./cmd/cloudflared
}

src_install(){
	dobin cloudflared
	einstalldocs
}
