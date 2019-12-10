# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 toolchain-funcs

DESCRIPTION="Fast and flexible Lua-based build system"
HOMEPAGE="https://matricks.github.com/bam/"
SRC_URI="https://github.com/matricks/bam/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-lang/lua-5.3:="
DEPEND="${RDEPEND}"
BDEPEND="doc? (
		${PYTHON_DEPS}
		media-gfx/graphviz
	)
	test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	if use doc || use test; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	default
	# There is no such file licence.txt
	sed -e '/license\.txt/d' -i scripts/gendocs.py || die
	tc-export CC
}

src_compile() {
	emake ${PN}
	if use doc; then
		"${EPYTHON}" scripts/gendocs.py || die "doc generation failed"
	fi
}

src_install() {
	dobin ${PN}
	if use doc; then
		dodoc docs/${PN}{.html,_logo.png}
	fi
}
