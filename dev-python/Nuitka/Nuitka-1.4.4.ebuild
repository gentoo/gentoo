# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1 flag-o-matic optfeature pypi

DESCRIPTION="Python to native compiler"
HOMEPAGE="
	https://www.nuitka.net/
	https://github.com/Nuitka/Nuitka/
	https://pypi.org/project/Nuitka/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~loong ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/scons[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? ( dev-util/ccache )
"

DOCS=( Changelog.pdf Developer_Manual.pdf README.pdf )

distutils-r1_src_prepare() {
	# remove vendored version of SCons that is Python2 only
	# this should be removed when upstream removes support for Python2
	rm -vR "nuitka/build/inline_copy/lib/scons-2.3.2/SCons" || die
	eapply_user
}

python_install() {
	distutils-r1_python_install
	doman doc/nuitka3.1 doc/nuitka3-run.1
}

python_test() {
	append-ldflags -Wl,--no-warn-search-mismatch
	./tests/basics/run_all.py search || die
}

pkg_postinst() {
	optfeature "support for stand-alone executables" app-admin/chrpath
}
