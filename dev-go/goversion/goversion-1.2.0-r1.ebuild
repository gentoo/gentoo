# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Print version used to build Go executables"
HOMEPAGE="https://github.com/rsc/goversion https://rsc.io/goversion"
SRC_URI="https://github.com/rsc/goversion/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	default
	cat <<- EOF > "${S}"/go.mod
		module rsc.io/goversion

		go 1.17
	EOF
	go-module_src_unpack
}

src_compile() {
	ego build -o ${PN} .
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
