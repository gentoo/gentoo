# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs vcs-snapshot

DESCRIPTION="A reference-guided aligner for next-generation sequencing technologies"
HOMEPAGE="https://github.com/wanpinglee/MOSAIK"
SRC_URI="https://github.com/wanpinglee/MOSAIK/archive/5c25216d3522d6a33e53875cd76a6d65001e4e67.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P}/src"

PATCHES=(
	"${FILESDIR}"/${P}-remove-platform-code.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-Wformat-security.patch
	"${FILESDIR}"/${P}-gcc7.patch
)

src_configure() {
	# readd default warning flags from build system
	append-flags -Wall -Wno-char-subscripts
	append-lfs-flags
	export BLD_PLATFORM=linux
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin bin/Mosaik*

	dodoc ../README

	insinto /usr/share/${PN}/examples
	doins -r ../demo/.
}
