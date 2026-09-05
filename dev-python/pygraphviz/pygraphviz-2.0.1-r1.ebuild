# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/pygraphviz/pygraphviz
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 flag-o-matic pypi toolchain-funcs

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="
	https://pygraphviz.github.io/
	https://github.com/pygraphviz/pygraphviz/
	https://pypi.org/project/pygraphviz/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv ~x86 ~x64-macos"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
# [cairo] is actually pangocairo, needed for gvplugin_pango.
DEPEND="
	media-gfx/graphviz:=[cairo]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig:0
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_configure() {
	# set to a meaningless path, it hardcodes /lib anyway; at least it
	# will stop it from adding a bunch of wrong RUNPATHs
	export GRAPHVIZ_PREFIX=${T}

	# upstream's solution to "not one of the random hardcoded paths" is
	# literally "add a bunch of -I -L flags yourself"
	append-cppflags $($(tc-getPKG_CONFIG) --cflags libcdt || die)
	local libdir=$($(tc-getPKG_CONFIG) --variable=libdir libcdt || die)
	# the build system will pass a bunch of "-l"s anyway
	append-ldflags $($(tc-getPKG_CONFIG) --libs-only-L libcdt || die) \
		-L"${libdir}/graphviz" -Wl,-rpath,"${libdir}/graphviz"
}

python_test() {
	rm -rf pygraphviz || die
	epytest --pyargs pygraphviz
}

python_install_all() {
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples

	distutils-r1_python_install_all
}
