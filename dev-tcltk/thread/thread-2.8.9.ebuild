# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-$(ver_rs 0- '-')"

DESCRIPTION="Tcl Thread extension"
HOMEPAGE="http://www.tcl.tk/"
SRC_URI="https://github.com/tcltk/${PN}/archive/refs/tags/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

DEPEND="dev-lang/tcl:0=[threads]"
RDEPEND="${DEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	opendir64 rewinddir64 closedir64 stat64 # used to test for Large File Support on AIX
)

S="${WORKDIR}"/${PN}-${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2.8.5-musl.patch )

src_configure() {
	econf --with-tclinclude="${EPREFIX}/usr/include" \
		--with-tcl="${EPREFIX}/usr/$(get_libdir)"
}
