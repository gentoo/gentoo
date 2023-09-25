# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="GLEP 63 compliance checker for OpenPGP keys"
HOMEPAGE="https://github.com/projg2/glep63-check/"
SRC_URI="
	https://github.com/projg2/glep63-check/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-crypt/gnupg"
DEPEND="
	test? (
		>=app-crypt/gnupg-2.2.29
		sys-libs/libfaketime
	)"

distutils_enable_tests unittest
