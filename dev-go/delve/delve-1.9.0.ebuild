# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A source-level debugger for the Go programming language"
HOMEPAGE="https://github.com/go-delve/delve"

SRC_URI="https://github.com/go-delve/delve/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT BSD BSD-2 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	go build -mod vendor -ldflags="-X main.Build=${PV}" -o "${S}/dlv" ./cmd/dlv || die
}

src_test() {
	local packages
	readarray -t packages < <(go list ./...)
	(( ${#packages[@]} > 0 )) || die "go list failed"
	# The first test fails, without network since it is calling go build ...
	# disabled for now. Future ebuilds will patch that test.
	go test -count 1 -p 1 -v "-ldflags=-X main.Build=${PV}" ${packages[@]:1} || die
}

src_install() {
	dobin dlv
	dodoc README.md CHANGELOG.md
}
