# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Manage .env files"
HOMEPAGE="https://github.com/theskumar/python-dotenv"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"

DEPEND="
	test? (
		>=dev-python/click-5[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/sh-1.09[${PYTHON_USEDEP}]
	)"

DOCS=( CHANGELOG.md README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-0.18.0-second-entrypoint.patch  # bug 798648
)

distutils_enable_tests --install pytest

src_install() {
	distutils-r1_src_install

	# Avoid collision with dev-ruby/dotenv (bug #798648)
	rm "${D}"/usr/bin/dotenv || die
}
