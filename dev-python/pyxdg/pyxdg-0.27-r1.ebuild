# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-rel-${PV}"
PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="A Python module to deal with freedesktop.org specifications"
HOMEPAGE="https://freedesktop.org/wiki/Software/pyxdg https://cgit.freedesktop.org/xdg/pyxdg/"
SRC_URI="https://github.com/takluyver/${PN}/archive/rel-${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

distutils_enable_tests pytest

python_test() {
	# epytest does not work here for some reason:
	# No such file or directory: '-vv'
	#
	# Can't import xdg unless already installed,
	# workaround with PYTHONPATH
	PYTHONPATH="${S}" pytest test/* -vv || die "Tests failed with ${EPYTHON}"
}
