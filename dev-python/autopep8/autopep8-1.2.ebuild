# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/autopep8/autopep8-1.2.ebuild,v 1.1 2015/07/27 19:57:26 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Automatically formats Python code to conform to the PEP 8 style guide"
HOMEPAGE="https://github.com/hhatto/autopep8 http://pypi.python.org/pypi/autopep8"
SRC_URI="https://github.com/hhatto/${PN}/tarball/ver${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/pep8-1.5.7[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	test? (	>=dev-python/pydiff-0.1.2[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent UnicodeDecodeError with LANG=C
	sed -e "/é/d" -i MANIFEST.in || die
	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test
	# from the travis.yml
	"${PYTHON}" test/test_autopep8.py || die
	"${PYTHON}" test/acid.py -aaa --experimental test/example.py || die
	"${PYTHON}" test/acid.py -aaa --experimental test/example_with_reduce.py || die
	"${PYTHON}" test/acid.py -aaa --compare-bytecode --experimental test/example.py  die
	"${PYTHON}" test/acid.py --aggressive --line-range 550 610 test/inspect_example.py || die
	"${PYTHON}" test/acid.py --line-range 289 925 test/vectors_example.py || die
	"${PYTHON}" test/test_suite.py || die
}

pkg_postinst() {
	ewarn "Since this version of autopep depends on >=dev-python/pep8-1.3"
	ewarn "it is affected by https://github.com/jcrocholl/pep8/issues/45"
	ewarn "(indentation checks inside triple-quotes)."
	ewarn "If you do not want to be affected by this, then add the"
	ewarn "following lines to your local package.mask:"
	ewarn "  >=dev-python/pep8-1.3"
	ewarn "  >=dev-python/autopep8-0.6"
}
