# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_CONFIG_NAME="doxygen_tree.config"
DOCS_DIR="doc"

inherit docs toolchain-funcs

DESCRIPTION="An STL-like tree class"
HOMEPAGE="https://github.com/kpeeters/tree.hh"
SRC_URI="https://github.com/kpeeters/tree.hh/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}.hh-${PV}"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

src_configure() {
	tc-export CXX
}

src_compile() {
	docs_compile
}

src_test() {
	cd src || die
	emake
	emake run_tests
}

src_install() {
	doheader src/tree.hh src/tree_util.hh
	dodoc -r examples
	einstalldocs
}
