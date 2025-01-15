# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Library for creating executables compatible with LaTeX restricted shell escape"
HOMEPAGE="
	https://github.com/gpoore/latexrestricted
	https://pypi.org/project/latexrestricted/
"
SRC_URI="
	https://github.com/gpoore/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LPPL-1.3c"
SLOT="0"
KEYWORDS="amd64"
