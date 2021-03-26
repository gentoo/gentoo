# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Libraries/utilities to handle ELF objects (BSD drop in replacement for libelf)"
HOMEPAGE="https://wiki.freebsd.org/LibElf"
SRC_URI="https://netcologne.dl.sourceforge.net/project/elftoolchain/Sources/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!dev-libs/elfutils
	!dev-libs/libelf"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-vcs/subversion
	sys-apps/lsb-release
	>=sys-devel/bmake-20210206
	virtual/yacc"

src_prepare() {
	default
	sed -i -e "s@cc@$(tc-getCC)@" common/native-elf-format || die
	sed -i -e "s@readelf@$(tc-getREADELF)@" common/native-elf-format || die
}

_bmake() {
	bmake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		RANLIB="$(tc-getRANLIB)" \
		"$@" || die
}

src_compile() {
	export MAKESYSPATH="${BROOT}"/usr/share/mk/bmake
	_bmake -C common
	_bmake -C libelf
}

src_install() {
	doheader common/elfdefinitions.h
	doheader libelf/{gelf,libelf}.h

	dolib.so libelf/libelf.so.1
	dosym libelf.so.1 /usr/$(get_libdir)/libelf.so

	dodoc README
}
