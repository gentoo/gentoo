# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Easily create mock objects on D-Bus for software testing"
HOMEPAGE="https://github.com/martinpitt/python-dbusmock"
SRC_URI="
	https://github.com/martinpitt/python-dbusmock/releases/download/${PV}/${P}.tar.gz
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

src_prepare() {
	# needed for unittest discovery
	> tests/__init__.py || die
	# linter tests, fragile to newer linter versions
	rm tests/test_code.py || die

	# Test is removed in master
	# https://github.com/martinpitt/python-dbusmock/commit/424719793c0a8e15ee05451cd58e21fb09914453
	# https://github.com/martinpitt/python-dbusmock/issues/75
	rm tests/test_accounts_service.py dbusmock/templates/accounts_service.py || die

	distutils-r1_src_prepare
}
