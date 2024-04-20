# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Checks mp3 files for consistency and prints several errors and warnings"
HOMEPAGE="https://code.google.com/p/mp3check/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.7-fix-buildsystem.patch
	"${FILESDIR}"/${PN}-0.8.7-fix-c++14-operator-delete.patch
)

src_configure() {
	# tfiletools.h:59:50: warning: dereferencing type-punned pointer will break
	# strict-aliasing rules [-Wstrict-aliasing]
	append-cxxflags -fno-strict-aliasing

	tc-export CXX
}

src_install() {
	dobin ${PN}
	doman *.1
}
