# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Module for RAR archive reading"
HOMEPAGE="
	https://github.com/markokr/rarfile/
	https://pypi.org/project/rarfile/
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="+compressed test"
REQUIRED_USE="test? ( compressed )"

RDEPEND="
	compressed? ( app-arch/unrar )
"

distutils_enable_tests pytest
