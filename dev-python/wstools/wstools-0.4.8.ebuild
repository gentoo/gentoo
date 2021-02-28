# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="WSDL parsing services package for Web Services for Python"
HOMEPAGE="https://github.com/pycontribs/wstools https://pypi.org/project/wstools/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/pbr[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${PN}-0.4.8-setup.patch )

distutils_enable_tests pytest
