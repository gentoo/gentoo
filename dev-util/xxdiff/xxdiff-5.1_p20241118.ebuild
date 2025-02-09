# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 qmake-utils

DESCRIPTION="Graphical file and directories comparator and merge tool"
HOMEPAGE="https://furius.ca/xxdiff/ https://github.com/blais/xxdiff"
COMMIT="a13d80f3339c5ec39d26b5155f33d0f2907a5629"
SRC_URI="https://github.com/blais/xxdiff/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scripts"
REQUIRED_USE="scripts? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	scripts? ( ${PYTHON_DEPS} )
"
DEPEND="
	${RDEPEND}
	app-alternatives/yacc
"
BDEPEND="
	scripts? (
		${DISTUTILS_DEPS}
		${PYTHON_DEPS}
	)
"

pkg_setup() {
	use scripts && python-single-r1_pkg_setup
}

src_prepare() {
	default
	use scripts && distutils-r1_src_prepare
}

src_configure() {
	pushd src >/dev/null || die
		# mimic src/Makefile.bootstrap
		eqmake6
		cat Makefile.extra >> Makefile || die
	popd || die
}

src_compile() {
	emake -C src MAKEDIR=.

	use scripts && distutils-r1_src_compile
}

src_install() {
	local DOCS=( CHANGES README* TODO doc/*.txt src/doc.txt tools )
	local HTML_DOCS=( doc/*.{png,html} src/doc.html )

	dobin bin/xxdiff
	doman "${S}"/src/xxdiff.1

	if use scripts; then
		distutils-r1_src_install
		# no port to py3
		rm "${ED}"/usr/bin/termdiff || die
	fi

	einstalldocs
}
