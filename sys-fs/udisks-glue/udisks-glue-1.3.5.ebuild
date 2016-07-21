# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools

DESCRIPTION="A tool to associate udisks events to user-defined actions"
HOMEPAGE="https://github.com/fernandotcl/udisks-glue"
SRC_URI="https://github.com/fernandotcl/udisks-glue/tarball/release-${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND=">=dev-libs/dbus-glib-0.100.2
	>=dev-libs/glib-2
	dev-libs/confuse"
RDEPEND="${COMMON_DEPEND}
	>=sys-fs/udisks-1.0.4-r5:0"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

DOCS=( ChangeLog README )

src_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}"
}

src_prepare() {
	eautoreconf
}
