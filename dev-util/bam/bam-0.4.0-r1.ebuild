# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-any-r1 toolchain-funcs

DESCRIPTION="Fast and flexible Lua-based build system"
HOMEPAGE="https://matricks.github.com/bam/"
SRC_URI="https://github.com/downloads/matricks/${PN}/${P}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/lua:="
DEPEND="${RDEPEND}
	doc? ( ${PYTHON_DEPS} )
	test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	cp "${FILESDIR}"/${PV}/Makefile "${S}"/Makefile || die "cp failed"
	epatch "${FILESDIR}"/${PV}/${P}-test.py.patch
	tc-export CC
}

src_compile() {
	emake ${PN}
	if use doc; then
		"${PYTHON}" scripts/gendocs.py || die "doc generation failed"
	fi
}

src_install() {
	dobin ${PN}
	if use doc; then
		dohtml docs/${PN}{.html,_logo.png}
	fi
}
