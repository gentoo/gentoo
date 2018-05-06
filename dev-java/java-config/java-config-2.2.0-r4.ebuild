# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# jython depends on java-config, so don't add it or things will break
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Java environment configuration query tool"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://dev.gentoo.org/~sera/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86"
IUSE="test"

DEPEND="test? (
		|| (
			sys-apps/portage[${PYTHON_USEDEP}]
			sys-apps/portage-mgorny[${PYTHON_USEDEP}]
		)
	)"

# baselayout-java is added as a dep till it can be added to eclass.
RDEPEND="
	!dev-java/java-config-wrapper
	sys-apps/baselayout-java
	|| (
		sys-apps/portage[${PYTHON_USEDEP}]
		sys-apps/portage-mgorny[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${PN}-2.2.0-prefix.patch )

python_install_all() {
	distutils-r1_python_install_all

	# This replaces the file installed by java-config-wrapper.
	dosym java-config-2 /usr/bin/java-config
}

python_test() {
	esetup.py test
}
