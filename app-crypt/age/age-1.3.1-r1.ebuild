# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A simple, modern and secure encryption tool (and Go library)"
HOMEPAGE="https://github.com/FiloSottile/age"
SRC_URI="https://github.com/FiloSottile/age/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~graaff/age/${P}-deps.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

src_prepare() {
	default
	mkdir bin || die
}

src_compile() {
	ego build -ldflags "-X main.Version=${PV}" -o bin filippo.io/age/cmd/...
}

src_test() {
	ego test filippo.io/age/cmd/...
}

src_install() {
	dobin bin/*
	doman doc/*.1

	local DOCS=( README.md )
	local HTML_DOCS=( doc/*.html )
	einstalldocs
}
