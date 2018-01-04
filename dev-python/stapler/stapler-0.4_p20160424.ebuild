# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

# Commit Date: 26th Apr 2016
COMMIT="7c153e6a8f52573ff886ebf0786b64e17699443a"

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
