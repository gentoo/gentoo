# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Manage .env files"
HOMEPAGE="https://github.com/theskumar/python-dotenv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="
	test? (
		>=dev-python/click-5[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/sh-1.09[${PYTHON_USEDEP}]
	)"

DOCS=( CHANGELOG.md README.md )

PATCHES=(
	# rename the entry point (note: old name is needed in tests)
	# https://bugs.gentoo.org/798648
	# also fix syntax since it doesn't seem to work anymore
	# https://bugs.gentoo.org/833389
	"${FILESDIR}"/python-dotenv-0.19.2-entry-points.patch
)

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	# Avoid collision with dev-ruby/dotenv (bug #798648)
	rm "${D}"/usr/bin/dotenv || die
}
