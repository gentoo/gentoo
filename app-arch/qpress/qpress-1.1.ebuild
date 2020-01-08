# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A portable file archiver using QuickLZ algorithm"
HOMEPAGE="http://www.quicklz.com/"
SRC_URI="http://www.quicklz.com/${PN}-${PV/./}-source.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1-fix-includes.patch
	"${FILESDIR}"/${PN}-1.1-fix-build-system.patch
)

src_configure() {
	tc-export CC CXX
	export LDLIBS="-lpthread"
}

src_install() {
	dobin ${PN}
}
