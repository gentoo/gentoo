# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 vcs-snapshot

# Commit Date: 15th December 2019
COMMIT="875325103234b4a3ed96a4a5167ff78c291edbff"

DESCRIPTION="Suite of tools for PDF files manipulation written in Python"
HOMEPAGE="https://github.com/hellerbarde/stapler"
SRC_URI="https://github.com/hellerbarde/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/PyPDF2[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
