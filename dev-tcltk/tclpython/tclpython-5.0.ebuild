# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit multilib python-single-r1 toolchain-funcs

DESCRIPTION="Python package for Tcl"
HOMEPAGE="http://jfontain.free.fr/tclpython.htm"
SRC_URI="https://github.com/amykyta3/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-lang/tcl:0="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	if python_is_python3; then
		PKG_NAME=tclpython3
	else
		PKG_NAME=tclpython
	fi
	emake PKG_NAME=${PKG_NAME} CC=$(tc-getCC)
}

src_test() {
	emake PKG_NAME=${PKG_NAME} CC=$(tc-getCC) test
}

src_install() {
	if python_is_python3; then
		insinto /usr/$(get_libdir)
		doins -r build/tclpython3/tclpython3
		fperms 775 /usr/$(get_libdir)/tclpython3/tclpython3.so.${PV}
		dosym tclpython3.so.${PV} /usr/$(get_libdir)/tclpython3/tclpython3.so
	else
		insinto /usr/$(get_libdir)
		doins -r build/tclpython/tclpython
		fperms 775 /usr/$(get_libdir)/tclpython/tclpython.so.${PV}
		dosym tclpython.so.${PV} /usr/$(get_libdir)/tclpython/tclpython3.so
	fi

	dodoc README.md VERSION.md
}
