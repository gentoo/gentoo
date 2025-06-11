# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..12} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_SINGLE_IMPL=1
PYPI_NO_NORMALIZE=1
PYPI_PN="ReText"

inherit desktop distutils-r1 optfeature virtualx xdg

DESCRIPTION="Simple editor for Markdown and reStructuredText"
HOMEPAGE="https://github.com/retext-project/retext https://github.com/retext-project/retext/wiki"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/retext-project/retext.git"
else
	inherit pypi
	KEYWORDS="amd64 ~riscv ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		>=dev-python/markups-3.1.1[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pyqt6[dbus,gui,printsupport,widgets,${PYTHON_USEDEP}]
		dev-python/python-markdown-math[${PYTHON_USEDEP}]
	')
"
# qmake6 from qtbase is used to find lrelease
BDEPEND="
	dev-qt/qtbase:6
	dev-qt/qttools:6[linguist]
	test? (
		${RDEPEND}
		$(python_gen_cond_dep '
			dev-python/pyqt6[testlib,${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests unittest

src_test() {
	QT_QPA_PLATFORM=minimal virtx distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install

	domenu data/me.mitya57.ReText.desktop
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "a local copy of the MathJax JavaScript library" dev-libs/mathjax
	optfeature "encoding detection" dev-python/chardet
	optfeature "dictionary support" dev-python/pyenchant
	optfeature "JavaScript support in preview" dev-python/pyqt6-webengine
}
