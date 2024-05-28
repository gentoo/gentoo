# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/radhermit/vimball.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	inherit pypi
fi

DESCRIPTION="A command-line vimball archive extractor"
HOMEPAGE="
	https://github.com/radhermit/vimball/
	https://pypi.org/project/vimball/
"

LICENSE="MIT"
SLOT="0"

distutils_enable_tests pytest
