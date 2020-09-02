# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="OpenBSD tool to sign and verify signatures on files"
HOMEPAGE="http://www.openbsd.org/ https://github.com/aperezdc/signify"
SRC_URI="https://github.com/aperezdc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/libbsd-0.8"
DEPEND="${RDEPEND}"

src_configure() {
	tc-export CC
	default
}

src_install() {
	dobin signify
	doman signify.1
}
