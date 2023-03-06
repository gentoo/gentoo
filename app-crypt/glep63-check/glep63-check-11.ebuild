# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="GLEP 63 compliance checker for OpenPGP keys"
HOMEPAGE="https://github.com/projg2/glep63-check/"
SRC_URI="
	https://github.com/projg2/glep63-check/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-crypt/gnupg"
DEPEND="
	test? (
		>=app-crypt/gnupg-2.3.3
		sys-libs/libfaketime
	)"

distutils_enable_tests unittest
