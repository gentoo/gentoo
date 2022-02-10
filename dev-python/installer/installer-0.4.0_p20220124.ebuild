# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

EGIT_COMMIT="05855a926b2e6d9a1be6d567300883b7a6ff3ce7"
DESCRIPTION="A library for installing Python wheels"
HOMEPAGE="
	https://pypi.org/project/installer/
	https://github.com/pradyunsg/installer/
	https://installer.readthedocs.io/en/latest/
"
# TODO: switch back to pradyunsg/ upstream when the CLI PR is merged
# https://github.com/pradyunsg/installer/pull/94
SRC_URI="
	https://github.com/takluyver/installer/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
	https://files.pythonhosted.org/packages/py2.py3/${PN::1}/${PN}/${P%_p*}-py2.py3-none-any.whl
		-> ${P%_p*}-py2.py3-none-any.whl.zip
"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# NB: newer git doesn't use mock anymore
BDEPEND="
	app-arch/unzip
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

# do not use any build system to avoid circular deps
python_compile() { :; }

python_test() {
	local -x PYTHONPATH=src
	epytest
}

python_install() {
	python_domodule src/installer "${WORKDIR}"/*.dist-info
}
