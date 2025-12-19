# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Chrpath can modify the rpath and runpath of ELF executables"
HOMEPAGE="https://directory.fsf.org/wiki/Chrpath"
SRC_URI="https://codeberg.org/pere/${PN}/archive/release_${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~x64-solaris"

PATCHES=(
	"${FILESDIR}"/${PN}-0.16-multilib.patch
	"${FILESDIR}"/${PN}-0.16-testsuite-1.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" docdir="${EPREFIX}/usr/share/doc/${P}" install || die
}
