# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utility to convert files in xfig format to OpenOffice.org Draw format"
HOMEPAGE="https://gitlab.com/acfbuerger/fig2sxd"
SRC_URI="https://gitlab.com/acfbuerger/fig2sxd/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/zlib:="
RDEPEND="${DEPEND}"

DOCS=( README.md changelog )
PATCHES=( "${FILESDIR}"/${PN}-0.20-phony-check.patch )

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" CXX="$(tc-getCXX)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
