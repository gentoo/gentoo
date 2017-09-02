# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

PLOCALES="ca cs cy da de es et eu fr hu it ja pl pt pt_BR ru sk sr sr@latin uk zh_TW"

inherit distutils-r1 virtualx l10n eutils

MY_PN="ReText"
MY_P="${MY_PN}-${PV/_/~}"

DESCRIPTION="Simple editor for Markdown and reStructuredText"
HOMEPAGE="https://github.com/retext-project/retext https://github.com/retext-project/retext/wiki"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+spell"

RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	>=dev-python/markups-2.0[${PYTHON_USEDEP}]
	>=dev-python/chardet-2.3[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,network,printsupport,webkit,widgets,${PYTHON_USEDEP}]
	spell? ( dev-python/pyenchant[${PYTHON_USEDEP}] )
"

S="${WORKDIR}"/${MY_P}

remove_locale() {
	find "${ED}" -name "retext_${1}.qm" -delete || die "Failed to remove locale ${1}."
}

python_test() {
	virtx esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	newicon {icons/,}${PN}.png
	newicon {icons/,}${PN}.svg

	l10n_for_each_disabled_locale_do remove_locale

	make_desktop_entry ${PN} "${MY_PN} Editor" ${PN} "Development;Utility;TextEditor"
}
