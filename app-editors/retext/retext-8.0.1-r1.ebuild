# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )
PYPI_NO_NORMALIZE=1
PYPI_PN="ReText"

inherit desktop distutils-r1 optfeature qmake-utils virtualx xdg

DESCRIPTION="Simple editor for Markdown and reStructuredText"
HOMEPAGE="https://github.com/retext-project/retext https://github.com/retext-project/retext/wiki"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/retext-project/retext.git"
else
	inherit pypi
	KEYWORDS="~amd64"
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
	dev-python/PyQt6[dbus,gui,printsupport,widgets,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools
	test? ( dev-python/PyQt6[testlib,${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-set-desktop-entry.patch
)

distutils_enable_tests unittest

pkg_setup() {
	# Needed for lrelease
	export PATH="$(qt5_get_bindir):${PATH}"
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	virtx eunittest
}

src_install() {
	distutils-r1_src_install

	newicon data/retext-kde5.png retext.png

	# Fixme: The application actually provides a desktop file which theoretically
	# could be used. So far though I could not make it install properly.
	make_desktop_entry ${PN} "ReText" ${PN} "Office;WordProcessor"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "dictionary support" dev-python/pyenchant

	einfo "Starting with retext-7.0.4 the markdown-math plugin is installed."
	einfo "Note that you can use different math delimiters, e.g. \(...\) for inline math."
	einfo "For more details take a look at:"
	einfo "https://github.com/mitya57/python-markdown-math#math-delimiters"
}

pkg_postrm() {
	xdg_icon_cache_update
}
