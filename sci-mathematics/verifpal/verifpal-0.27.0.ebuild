# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Cryptographic protocol analysis for real-world protocols"
HOMEPAGE="https://verifpal.com/
	https://source.symbolic.software/verifpal/verifpal/"
SRC_URI="
	https://source.symbolic.software/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
	https://dev.gentoo.org/~xgqt/distfiles/deps/${P}-deps.tar.xz
"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${PN}-0.27.0-no-external-generate.patch )

DOCS=( README.md examples )

src_compile() {
	local -a go_buildargs=(
		-trimpath
		-gcflags="-e"
		-ldflags="-s -w"
	)
	ego build "${go_buildargs[@]}" ./cmd/verifpal
}

src_install() {
	exeinto /usr/bin
	doexe "${PN}"

	einstalldocs
}
