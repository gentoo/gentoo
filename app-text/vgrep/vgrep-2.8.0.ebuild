# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A pager for grep, git-grep and similar grep implementations"
HOMEPAGE="https://github.com/vrothberg/vgrep"
SRC_URI="https://github.com/vrothberg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"

# tests just run golangci-lint
RESTRICT="test"

BDEPEND="dev-go/go-md2man"

src_prepare() {
	default
	sed -e '/-ldflags/s/-s //' -i Makefile || die # bug 795345
}

src_compile() {
	emake build
}

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}
