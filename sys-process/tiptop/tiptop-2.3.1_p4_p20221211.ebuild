# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

GIT_COMMIT="529886d445ec32febad14246245372a8f244b3eb"

DESCRIPTION="top for performance counters"
HOMEPAGE="https://github.com/FeCastle/tiptop"
SRC_URI="https://github.com/FeCastle/tiptop/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" http://deb.debian.org/debian/pool/main/t/tiptop/tiptop_$(ver_cut 1-3)-$(ver_cut 5).debian.tar.xz"
S="${WORKDIR}/${PN}-${GIT_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/libxml2:2
	dev-libs/papi
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
# drop when patch$ tiptop-2.3.1-implicit-function-declaration.patch is merged upstream
BDEPEND="app-alternatives/lex"

PATCHES=(
	"${WORKDIR}"/debian/patches
	"${FILESDIR}"/${PN}-2.3.1-tinfo.patch #618124
	"${FILESDIR}"/${PN}-2.3.1-advise-user-to-run-as-root-when-paranoid_level-3.patch
	"${FILESDIR}"/${PN}-2.3.1-implicit-function-declaration.patch
)

src_prepare() {
	default
	eautoreconf #618124
}
