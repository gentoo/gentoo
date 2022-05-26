# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Vulnerability checker using data scraped from Gentoo Bugzilla"
HOMEPAGE="https://github.com/mgorny/kuroneko/"
SRC_URI="
	https://github.com/mgorny/kuroneko/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="scraper"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	sys-apps/pkgcore[${PYTHON_USEDEP}]
	scraper? (
		dev-python/bracex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)"
BDEPEND="
	test? (
		dev-python/bracex[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
