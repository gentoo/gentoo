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
	app-arch/libarchive:=
	!dev-libs/elfutils
	!dev-libs/libelf"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-vcs/subversion
	sys-apps/lsb-release
	>=sys-devel/bmake-20210314-r1
	virtual/yacc"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default

	# needs unpackaged TET tools
	rm -r test || die

	sed -i -e "s@cc@$(tc-getCC)@" common/native-elf-format || die
	sed -i -e "s@readelf@$(tc-getREADELF)@" common/native-elf-format || die
}

src_configure() {
	tc-export AR CC LD RANLIB
	export MAKESYSPATH="${BROOT}"/usr/share/mk/bmake
}

src_compile() {
	bmake || die
}

src_install() {
	bmake \
		DESTDIR="${D}" \
		BINDIR="${EPREFIX}"/usr/bin/${CHOST}-elftoolchain \
		LIBDIR="${EPREFIX}"/usr/$(get_libdir) \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		install || die

	# remove static libraries
	find "${ED}" -name '*.a' -delete || die
}
