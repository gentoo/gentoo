# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A backend script to aid installing Python packages in Gentoo"
HOMEPAGE="
	https://pypi.org/project/gpep517/
	https://github.com/mgorny/gpep517/
"
SRC_URI="
	https://github.com/mgorny/gpep517/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/installer-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

# do not use any build system to avoid circular deps
python_compile() { :; }

python_install() {
	python_domodule gpep517
	python_newscript - gpep517 <<-EOF
		#!/usr/bin/python
		import sys
		from gpep517.__main__ import main
		sys.exit(main())
	EOF
}
