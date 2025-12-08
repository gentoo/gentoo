# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_PN=${PN/-/.}
# This is a backport from Python 3.12.
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Backport of CPython tarfile module (from Python 3.12)"
HOMEPAGE="
	https://github.com/jaraco/backports.tarfile/
	https://pypi.org/project/backports.tarfile/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="
	test? (
		dev-python/jaraco-test[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_configure() {
	grep -q 'build-backend = "setuptools' pyproject.toml ||
		die "Upstream changed build-backend, recheck"
	# write a custom pyproject.toml to ease setuptools bootstrap
	cat > pyproject.toml <<-EOF || die
		[build-system]
		requires = ["flit_core >=3.2,<4"]
		build-backend = "flit_core.buildapi"

		[project]
		name = "backports.tarfile"
		version = "${PV}"
		description = "Backport of CPython tarfile module"
	EOF
}

python_test() {
	local EPYTEST_DESELECT=()
	case ${EPYTHON} in
		pypy3.11)
			EPYTEST_DESELECT+=(
				# https://github.com/jaraco/backports.tarfile/issues/10
				tests/test_tarfile.py::ListTest::test_list_verbose
				tests/test_tarfile.py::GzipListTest::test_list_verbose
				tests/test_tarfile.py::Bz2ListTest::test_list_verbose
				tests/test_tarfile.py::LzmaListTest::test_list_verbose
				tests/test_tarfile.py::TestExtractionFilters::test_modes
			)
			;;
	esac

	epytest
}
