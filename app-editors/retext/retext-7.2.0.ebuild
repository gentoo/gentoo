# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Please don't add pypy support before testing if it's actually supported. The
# old compat matrix is no longer accessible as of 2021-02-13 but stated back
# in 2020-07-05 that PyQt5 was explicitly not supported.
PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1 optfeature virtualx xdg-utils

MY_PN="ReText"
MY_P="${MY_PN}-${PV/_/~}"

DESCRIPTION="Simple editor for Markdown and reStructuredText"
HOMEPAGE="https://github.com/retext-project/retext https://github.com/retext-project/retext/wiki"

if [[ ${PV} == *9999 ]]
	then
		inherit git-r3
		EGIT_REPO_URI="https://github.com/retext-project/retext.git"
	else
		SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
		KEYWORDS="~amd64 ~x86"
		S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2+"
SLOT="0"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/markups[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/python-markdown-math[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,printsupport,widgets,${PYTHON_USEDEP}]
	dev-python/PyQtWebEngine[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	esetup.py test
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "dictionary support" dev-python/pyenchant

	einfo "Starting with retext-7.0.4 the markdown-math plugin is installed."
	einfo "Note that you can use different math delimiters, e.g. \(...\) for inline math."
	einfo "For more details take a look at:"
	einfo "https://github.com/mitya57/python-markdown-math#math-delimiters"
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
