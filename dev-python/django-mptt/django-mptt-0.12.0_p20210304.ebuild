# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

COMMIT="017c591c6ed2c43281ee2eba6b464c719578fc1d"

DESCRIPTION="Utilities for modified preorder tree traversal and trees of model instances"
HOMEPAGE="https://github.com/django-mptt/django-mptt"
SRC_URI="https://github.com/django-mptt/django-mptt/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${COMMIT}"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/django-js-asset[${PYTHON_USEDEP}]
"

# DEPEND="
#	test? (
#		${RDEPEND}
#		dev-python/mock-django[${PYTHON_USEDEP}]
#
#	)
# "

# TODO: fix test
# distutils_enable_tests pytest
