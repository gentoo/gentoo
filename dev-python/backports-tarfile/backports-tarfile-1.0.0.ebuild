# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/.}
# This is a backport from Python 3.12.
PYTHON_COMPAT=( pypy3 python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Backport of CPython tarfile module (from Python 3.12)"
HOMEPAGE="
	https://github.com/jaraco/backports.tarfile/
	https://pypi.org/project/backports.tarfile/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~x86"

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
