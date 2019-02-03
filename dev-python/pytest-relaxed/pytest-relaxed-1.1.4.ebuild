# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Because of its <pytest-3.3 constraint, python3_7 can't be added
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="py.test plugin for relaxed test discovery and organization"
HOMEPAGE="https://pypi.org/project/pytest-relaxed/ https://github.com/bitprophet/pytest-relaxed"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris"
IUSE="test"

RDEPEND="
	>=dev-python/pytest-3[${PYTHON_USEDEP}]
	<dev-python/pytest-3.3
	>=dev-python/six-1[${PYTHON_USEDEP}]
	>=dev-python/decorator-4[${PYTHON_USEDEP}]
"

# This package is a broken mess upstream. Tests don't work. Fortunately, it's
# not actually used by many packages.
RESTRICT="test"

PATCHES=(
	# We strip pytest-relaxed's entry point to stop it from autoloading on all
	# tests. When this package is installed, it has the habit of being
	# autoloaded everywhere and break every test. If you want to load it, add
	# "-p pytest_relaxed.plugin" to your pytest invocation.
	"${FILESDIR}/${PN}-1.1.4-no-autoload.patch"
)

python_test() {
	pytest -v || die "tests failed with ${EPYTHON}"
}
