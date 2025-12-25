# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Powerful and highly extensible document and bibliography manager"
HOMEPAGE="
	https://pypi.org/project/papis
	https://github.com/papis/papis
"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3+"
SLOT="0"
IUSE="rofi"

RDEPEND="
	>=dev-python/arxiv2bib-1.0.7[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.4.1[${PYTHON_USEDEP}]
	>=dev-python/bibtexparser-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/click-7.0.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.2[${PYTHON_USEDEP}]
	>=dev-python/doi-0.1.1[${PYTHON_USEDEP}]
	dev-python/dominate[${PYTHON_USEDEP}]
	>=dev-python/filetype-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/habanero-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/isbnlib-3.9.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.3.5[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-2.0.5[${PYTHON_USEDEP}]
	dev-python/pyaml[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.11.1[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-1.2.6[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.30[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7[${PYTHON_USEDEP}]

	rofi? (
		x11-misc/rofi
		dev-python/papis-rofi[${PYTHON_USEDEP}]
	)
"
