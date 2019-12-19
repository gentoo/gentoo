# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="https://github.com/ovalhub/pyicu"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}
	dev-libs/icu:="
DEPEND="${RDEPEND}"
BDEPEND="test? (
		${RDEPEND}
		dev-python/six
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.2-testLocaleMatcher_pytest_old_icu.patch
)

S="${WORKDIR}/${MY_P}"

DOCS=(CHANGES CREDITS README.md)

distutils_enable_tests pytest
