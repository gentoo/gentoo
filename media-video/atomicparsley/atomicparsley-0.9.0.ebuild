# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=AtomicParsley-source-${PV}

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Command line program for manipulating iTunes-style metadata in MPEG4 files"
HOMEPAGE="http://atomicparsley.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-glibc-2.10.patch
	"${FILESDIR}"/${P}-environment.patch
)

src_compile() {
	# APar_sha1.cpp:116:47 and 117:43: warning: dereferencing type-punned
	# pointer will break strict-aliasing rules
	append-flags -fno-strict-aliasing
	tc-export CXX
	./build || die
}

src_install() {
	dobin AtomicParsley
	dodoc *.{txt,rtf}
}
