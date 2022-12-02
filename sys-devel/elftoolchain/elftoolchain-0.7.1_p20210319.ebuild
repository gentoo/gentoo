# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_COMMIT="58584bb3e5276586e1cb246641525f72843ebc08"

DESCRIPTION="Libraries/utilities to handle ELF objects (BSD drop in replacement for libelf)"
HOMEPAGE="https://wiki.freebsd.org/LibElf"
SRC_URI="https://github.com/elftoolchain/elftoolchain/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/libarchive:=
	dev-libs/uthash
	!dev-libs/elfutils
	!dev-libs/libelf"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-vcs/subversion
	sys-apps/lsb-release
	>=sys-devel/bmake-20210314-r1
	app-alternatives/yacc"

src_prepare() {
	default

	sed -e 's/-Werror//' -i libelf/os.Linux.mk || die

	# use system uthash
	rm common/{utarray,uthash}.h || die

	# needs unpackaged TET tools
	rm -r test || die
}

src_configure() {
	# -pg is used and the two are incompatible
	filter-flags -fomit-frame-pointer
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
