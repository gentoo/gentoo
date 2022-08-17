# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please don't add pypy support before testing if it's actually supported. The
# old compat matrix is no longer accessible as of 2021-02-13 but stated back
# in 2020-07-05 that PyQt5 was explicitly not supported.
PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1 optfeature qmake-utils virtualx xdg

MY_PN="ReText"
MY_P="${MY_PN}-${PV/_/~}"

DESCRIPTION="Simple editor for Markdown and reStructuredText"
HOMEPAGE="https://github.com/retext-project/retext https://github.com/retext-project/retext/wiki"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/retext-project/retext.git"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	>=dev-python/markups-3.1.1[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/python-markdown-math[${PYTHON_USEDEP}]
	dev-python/PyQt5[dbus,gui,printsupport,widgets,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools
	test? ( dev-python/PyQt5[testlib,${PYTHON_USEDEP}] )
"

distutils_enable_tests unittest

pkg_setup() {
	# Needed for lrelease
	export PATH="$(qt5_get_bindir):${PATH}"
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	eunittest || die
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "dictionary support" dev-python/pyenchant
	# See https://bugs.gentoo.org/772197.
	optfeature "rendering with webengine" dev-python/PyQtWebEngine

	einfo "Starting with retext-7.0.4 the markdown-math plugin is installed."
	einfo "Note that you can use different math delimiters, e.g. \(...\) for inline math."
	einfo "For more details take a look at:"
	einfo "https://github.com/mitya57/python-markdown-math#math-delimiters"
}
