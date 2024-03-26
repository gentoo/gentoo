# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gap-pkg

MY_P="SmallGrp-${PV}"
DESCRIPTION="The GAP Small Groups Library"
SLOT="0"
SRC_URI="https://github.com/gap-packages/smallgrp/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Artistic-2"
KEYWORDS="~amd64"

RDEPEND="dev-gap/gapdoc"
gap-pkg_enable_tests

src_install() {
	# Define the variable here so globbing will work
	GAP_PKG_EXTRA_INSTALL=( id* small* )
	gap-pkg_src_install
}
