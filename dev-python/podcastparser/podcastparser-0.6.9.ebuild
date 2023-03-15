# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Podcast parser for the gpodder client"
HOMEPAGE="
	https://github.com/gpodder/podcastparser/
	https://pypi.org/project/podcastparser/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 x86"

distutils_enable_tests pytest
