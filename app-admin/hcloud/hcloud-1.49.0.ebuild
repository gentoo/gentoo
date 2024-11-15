# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A command-line interface for Hetzner Cloud"
HOMEPAGE="https://github.com/hetznercloud/cli"
SRC_URI="https://dev.gentoo.org/~ago/distfiles/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_compile() {
	ego build -o ${PN} -ldflags "-w -X github.com/hetznercloud/cli/internal/version.versionPrerelease=gentoo" ./cmd/${PN}
}

src_test() {
	./hcloud version
	if [[ $? -ne 0 ]]
	then
		die "hcloud version test failed"
	fi

	# Avoid error like:
	# -buildmode=pie not supported when -race is enabled on linux/amd64
	GOFLAGS=${GOFLAGS//-buildmode=pie}
	ego test -coverpkg=./... -coverprofile=coverage.txt -v -race ./...
}

src_install() {
	dobin ${PN}
}
