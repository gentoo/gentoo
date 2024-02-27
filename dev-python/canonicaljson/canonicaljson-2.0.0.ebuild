# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Canonical JSON"
HOMEPAGE="
	https://github.com/matrix-org/python-canonicaljson/
	https://pypi.org/project/canonicaljson/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64"

distutils_enable_tests unittest
