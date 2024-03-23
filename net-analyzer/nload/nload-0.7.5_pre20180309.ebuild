# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

GIT_REV="8f92dc04fad283abdd2a4538cd4c2093d957d9da"

DESCRIPTION="Real time network traffic monitor for the command line interface"
HOMEPAGE="http://www.roland-riegel.de/nload/index.html https://github.com/rolandriegel/nload"
SRC_URI="https://github.com/rolandriegel/nload/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc x86"

RDEPEND=">=sys-libs/ncurses-5.2:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.5_pre-tinfo.patch
	"${FILESDIR}"/${PN}-0.7.5_pre-Makefile-spec-don-t-compress-man-page.patch
)

S="${WORKDIR}/${PN}-${GIT_REV}"

src_prepare() {
	default
	sed -i \
		-e "/AC_INIT/ s/0\.7\.4/${PV} (Gentoo)/" \
		configure.ac \
		|| die "Failed to patch configure.ac"
	eautoreconf
}
