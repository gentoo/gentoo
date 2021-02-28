# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Sphinx Doxygen renderer"
HOMEPAGE="https://breathe.readthedocs.io/en/latest/"
SRC_URI="https://github.com/michaeljones/breathe/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	app-doc/doxygen
	dev-python/docutils[${PYTHON_USEDEP}]
	>=dev-python/sphinx-3.0.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-texlive/texlive-bibtexextra
	dev-texlive/texlive-fontsextra
	dev-texlive/texlive-fontutils
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
"

distutils_enable_tests pytest
