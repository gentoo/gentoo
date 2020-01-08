# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Chrpath can modify the rpath and runpath of ELF executables"
HOMEPAGE="https://directory.fsf.org/wiki/Chrpath"
SRC_URI="https://alioth-archive.debian.org/releases/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

PATCHES=(
	"${FILESDIR}"/${P}-multilib.patch
	"${FILESDIR}"/${P}-testsuite-1.patch
	"${FILESDIR}"/${P}-solaris.patch
)

src_prepare() {
	default
	# disable installing redundant docs in the wrong dir
	sed -i -e '/doc_DATA/d' Makefile.am || die
	# fix for automake-1.13, #467538
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	if ! use static-libs; then
		find "${D}" -name "*.la" -delete || die
	fi
}
