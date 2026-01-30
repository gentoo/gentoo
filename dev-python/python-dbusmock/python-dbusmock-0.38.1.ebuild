# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/martinpitt/python-dbusmock
PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 pypi

DESCRIPTION="Easily create mock objects on D-Bus for software testing"
HOMEPAGE="
	https://github.com/martinpitt/python-dbusmock/
	https://pypi.org/project/python-dbusmock/
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		sys-power/upower
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# linter tests, fragile to newer linter versions
	tests/test_code.py
)

src_prepare() {
	# dev-python/dbus-python uses autotools, so no .dist-info there
	sed -i '/dbus-python/d' pyproject.toml setup.cfg || die

	distutils-r1_src_prepare
}

python_test() {
	# tests are fragile to long socket paths
	local -x TMPDIR=/tmp
	# Tests break if XDG_DATA_DIRS is modified by flatpak install
	unset XDG_DATA_DIRS
	epytest
}
