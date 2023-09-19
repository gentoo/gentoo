# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Helpers for better testing"
HOMEPAGE="https://github.com/fluxx/exam"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/mock[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
