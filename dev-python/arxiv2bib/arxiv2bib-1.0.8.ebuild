# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="Get metadata for academic papers from arXiv.org in BibTeX format."
HOMEPAGE="
	https://pypi.org/project/arxiv2bib
	https://nathangrigg.github.io/arxiv2bib
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
