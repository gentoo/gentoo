# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${PN}-$(ver_rs 0- '-')"
TCLCONFIGId=4a924db4fb37fa0c7cc2ae987b294dbaa97bc713

DESCRIPTION="Tcl Thread extension"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="
	https://github.com/tcltk/${PN}/archive/refs/tags/${MY_P}.tar.gz
	https://github.com/tcltk/tclconfig/archive/${TCLCONFIGId}.tar.gz
		-> tclconfig-2023.12.11.tar.gz
"

S="${WORKDIR}"/${PN}-${MY_P}
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="dev-lang/tcl:0=[threads]"
RDEPEND="${DEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	opendir64 readdir64 rewinddir64 closedir64 stat64 # used to test for Large File Support on AIX
)

PATCHES=( "${FILESDIR}"/${PN}-2.8.5-musl.patch )

src_prepare() {
	ln -s ../tclconfig-${TCLCONFIGId} tclconfig || die
	echo "unknown" > manifest.uuid || die
	default

	# Search for libs in libdir not just exec_prefix/lib
	sed -i -e 's:${exec_prefix}/lib:${libdir}:' \
		aclocal.m4 || die "sed failed"

	eautoreconf
}

src_configure() {
	econf --with-tclinclude="${EPREFIX}/usr/include" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}
