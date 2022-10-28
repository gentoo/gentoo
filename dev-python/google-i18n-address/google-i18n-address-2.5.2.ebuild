# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Google's i18n address metadata repository"
HOMEPAGE="https://pypi.org/project/google-i18n-address/"
# Using the github release, as it contains the tests (unlike the pypi artifact).
SRC_URI="https://github.com/mirumee/google-i18n-address/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest
