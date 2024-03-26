# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

DESCRIPTION="Polycyclic presentations for matrix groups"
SLOT="0"
SRC_URI="https://github.com/gap-packages/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
KEYWORDS="~amd64"

RDEPEND="dev-gap/polycyclic
	dev-gap/radiroot
	dev-gap/alnuth"

# These are "examples," but they're used by non-example code,
# and removing or renaming them will cause problems:
#
#   https://github.com/gap-packages/polenta/issues/9
#
GAP_PKG_EXTRA_INSTALL=( exam )
gap-pkg_enable_tests
