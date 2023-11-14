# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# jython depends on java-config, so don't add it or things will break
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 prefix

DESCRIPTION="Java environment configuration query tool"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( sys-apps/portage[${PYTHON_USEDEP}] )"

# baselayout-java is added as a dep till it can be added to eclass.
RDEPEND="
	sys-apps/baselayout-java
	sys-apps/portage[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/2.3.2-fix-deprecated-test-methods.patch" )

python_configure_all() {
	# setup.py fails to update this file
	eprefixify src/launcher.bash
}

python_install_all() {
	distutils-r1_python_install_all

	# This replaces the file installed by java-config-wrapper.
	dosym java-config-2 /usr/bin/java-config
}

python_test() {
	esetup.py test
}
