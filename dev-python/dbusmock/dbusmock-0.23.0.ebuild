# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easily create mock objects on D-Bus for software testing"
HOMEPAGE="https://github.com/martinpitt/python-dbusmock"
SRC_URI="https://github.com/martinpitt/${MY_PN}/releases/download/${PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

src_prepare() {
	# needed for unittest discovery
	> tests/__init__.py || die
	# linter tests, fragile to newer linter versions
	rm tests/test_code.py || die

	distutils-r1_src_prepare
}
