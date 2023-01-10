# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1

COMMIT="382f1edc62296e071093a5419811a2fca9d78d93"

DESCRIPTION="Suite of tools for PDF files manipulation written in Python"
HOMEPAGE="https://github.com/hellerbarde/stapler"
SRC_URI="https://github.com/hellerbarde/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="test? ( dev-python/pypdf[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/pypdf[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

PATCHES=( "${FILESDIR}"/${P}-fix-tests-for-PyPDF2-2.x.patch
	"${FILESDIR}"/${P}-port-to-PyPDF2-3.0.0.patch
	"${FILESDIR}"/${P}-use-poetry-core-backend-for-PEP517.patch
	"${FILESDIR}"/${P}-PyPDF2-to-pypdf.patch )
