# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="An immutable wrapper around dictionaries"
HOMEPAGE="
	https://github.com/corenting/immutabledict/
	https://pypi.org/project/immutabledict/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

distutils_enable_tests pytest
