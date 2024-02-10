# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Julian dates from proleptic Gregorian and Julian calendars"
HOMEPAGE="https://github.com/phn/jdcal"

LICENSE="BSD"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"
SLOT="0"

distutils_enable_tests pytest
