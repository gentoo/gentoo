# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

EGIT_COMMIT="382f1edc62296e071093a5419811a2fca9d78d93"
MY_P="${PN}-${EGIT_COMMIT}"
DESCRIPTION="Suite of tools for PDF files manipulation written in Python"
HOMEPAGE="
	https://github.com/hellerbarde/stapler/
	https://pypi.org/project/stapler/
"
SRC_URI="
	https://github.com/hellerbarde/stapler/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/pypdf[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}"/${P}-fix-tests-for-PyPDF2-2.x.patch
	"${FILESDIR}"/${P}-port-to-PyPDF2-3.0.0.patch
	"${FILESDIR}"/${P}-use-poetry-core-backend-for-PEP517.patch
	"${FILESDIR}"/${P}-PyPDF2-to-pypdf-r1.patch
)
