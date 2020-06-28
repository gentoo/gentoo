# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit go-module

DESCRIPTION="A pager for grep, git-grep and similar grep implementations"
HOMEPAGE="https://github.com/vrothberg/vgrep"
SRC_URI="https://github.com/vrothberg/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ MIT MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64"

# Uses golangci-lint
RESTRICT="test"

DOCS=( README.md )

# go binary
QA_PRESTRIPPED="usr/bin/vgrep"

src_compile() {
	emake build
}

src_install() {
	local prefix="${D}/usr"
	mkdir -p "${prefix}"/bin || die

	emake PREFIX="${prefix}" install
}
