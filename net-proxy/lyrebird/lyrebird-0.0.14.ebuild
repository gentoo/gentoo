# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

MY_PN="obfs4proxy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An obfuscating proxy supporting Tor's pluggable transport protocol obfs4"
HOMEPAGE="https://gitlab.com/yawning/obfs4"
SRC_URI="https://gitlab.com/yawning/obfs4/-/archive/${MY_P}/obfs4-${MY_P}.tar.gz -> ${MY_P}.tar.gz
	https://dev.gentoo.org/~marecki/dists/${CATEGORY}/${PN}/${MY_P}-deps.tar.xz"

# See https://gitlab.com/yawning/obfs4/-/issues/5#note_573104796 for licence clarification
LICENSE="BSD CC0-1.0 BZIP2 GPL-3+ MIT public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~riscv x86"

S="${WORKDIR}/obfs4-${MY_P}"

DOCS=( README.md ChangeLog LICENSE-GPL3.txt doc/obfs4-spec.txt )

src_compile() {
	go build -o ${MY_PN}/${MY_PN} ./${MY_PN} || die
}

src_install() {
	default
	dobin ${MY_PN}/${MY_PN}
	doman doc/${MY_PN}.1
}
