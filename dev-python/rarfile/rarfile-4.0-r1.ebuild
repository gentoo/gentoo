# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTLS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )
inherit distutils-r1 pypi

DESCRIPTION="Module for RAR archive reading"
HOMEPAGE="https://github.com/markokr/rarfile"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="+compressed test"
REQUIRED_USE="test? ( compressed )"

RDEPEND="compressed? ( app-arch/unrar )"

PATCHES=( "${FILESDIR}"/${P}.patch )

distutils_enable_tests pytest
