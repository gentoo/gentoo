# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( pypy3_11 python3_{11..14} python3_{13,14}t )

inherit distutils-r1

DESCRIPTION="A backend script to aid installing Python packages in Gentoo"
HOMEPAGE="
	https://pypi.org/project/gpep517/
	https://github.com/projg2/gpep517/
"
SRC_URI="
	https://github.com/projg2/gpep517/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/installer-0.5.0[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest -o tmp_path_retention_policy=all
}

python_install() {
	python_domodule gpep517
	python_newscript - gpep517 <<-EOF
		#!${EPREFIX}/usr/bin/python
		import sys
		from gpep517.__main__ import main
		sys.exit(main())
	EOF
}
