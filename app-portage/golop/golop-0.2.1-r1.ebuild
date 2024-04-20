# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="A pure Go re-implementation of genlop"
HOMEPAGE="https://github.com/klausman/golop"
SRC_URI="https://github.com/klausman/golop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

src_compile() {
	ego build -v -o ${PN}
}

src_install() {
	dobin ${PN}

	local DOCS=( README.md )
	einstalldocs
}
