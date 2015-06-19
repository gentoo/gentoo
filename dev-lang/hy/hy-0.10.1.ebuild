# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/hy/hy-0.10.1.ebuild,v 1.2 2014/11/25 19:02:35 pacho Exp $

EAPI=5

RESTRICT="test" # needs some pointy sticks. Seriously.
PYTHON_COMPAT=(python2_7 python3_3 python3_4)

inherit distutils-r1
DESCRIPTION="A LISP dialect running in python"
HOMEPAGE="http://hylang.org/"
SRC_URI="https://github.com/hylang/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/flake8[${PYTHON_USEDEP}]
	>=dev-python/rply-0.7.0[${PYTHON_USEDEP}]
	dev-python/astor[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/tox[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

python_test() {
	nosetests || die "Tests failed under ${EPYTHON}"
}
