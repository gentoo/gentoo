# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Jade syntax adapter for Django, Jinja2 and Mako templates"
HOMEPAGE="https://github.com/syrusakbary/pyjade"
SRC_URI="https://pypi.python.org/packages/4a/04/396ec24e806fd3af7ea5d0f3cb6c7bbd4d00f7064712e4dd48f24c02ca95/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test" # Need broken pyramid, bug #509518
IUSE="" #test

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
#	test? (
#		dev-python/nose[${PYTHON_USEDEP}]
#		dev-python/django[${PYTHON_USEDEP}]
#		dev-python/jinja[${PYTHON_USEDEP}]
#		www-servers/tornado[${PYTHON_USEDEP}]
#		dev-python/pyramid[${PYTHON_USEDEP}]
#		dev-python/mako[${PYTHON_USEDEP}]
#	)
