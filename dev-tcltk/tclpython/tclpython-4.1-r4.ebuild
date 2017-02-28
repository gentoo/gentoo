# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit eutils multilib python-single-r1 toolchain-funcs

DESCRIPTION="Python package for Tcl"
HOMEPAGE="http://jfontain.free.fr/tclpython.htm"
SRC_URI="http://jfontain.free.fr/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-lang/tcl:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-python-3.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"
}

src_compile() {
	local cfile="tclpython tclthread"
	for src in ${cfile}; do
		compile="$(tc-getCC) -shared -fPIC ${CFLAGS} -I$(python_get_includedir) -c ${src}.c"
		einfo "${compile}"
		eval "${compile}" || die
	done

	link="$(tc-getCC) -fPIC -shared ${LDFLAGS} -o tclpython.so.${PV} tclpython.o tclthread.o -lpthread -lutil $(python_get_LIBS) -ltcl"
	einfo "${link}"
	eval "${link}" || die
}

src_install() {
	insinto /usr/$(get_libdir)/tclpython
	doins tclpython.so.${PV} pkgIndex.tcl
	fperms 775 /usr/$(get_libdir)/tclpython/tclpython.so.${PV}
	dosym tclpython.so.${PV} /usr/$(get_libdir)/tclpython/tclpython.so

	dodoc CHANGES INSTALL README
	dohtml tclpython.htm
}
