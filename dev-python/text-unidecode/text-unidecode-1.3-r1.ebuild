# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="The most basic port of the Text::Unidecode Perl library"
HOMEPAGE="
	https://pypi.org/project/text-unidecode/
	https://github.com/kmike/text-unidecode/
"

LICENSE="|| ( Artistic GPL-2+ )"
SLOT="0"
KEYWORDS="amd64 ~ppc64 ~riscv x86"

distutils_enable_tests pytest
