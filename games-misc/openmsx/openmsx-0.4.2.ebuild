# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit python-any-r1

DESCRIPTION="Open source music base set for OpenTTD"
HOMEPAGE="https://wiki.openttd.org/en/Basesets/OpenMSX https://github.com/OpenTTD/OpenMSX"
SRC_URI="https://cdn.openttd.org/openmsx-releases/${PV}/${P}-source.tar.xz"
S="${WORKDIR}/${P}-source"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
# Don't appear to be meaningful
RESTRICT="test"

BDEPEND="${PYTHON_DEPS}"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_install() {
	insinto /usr/share/openttd/baseset/${P}
	doins ${P}/{*.mid,openmsx.obm}
	dodoc ${P}/{changelog,readme}.txt
}
