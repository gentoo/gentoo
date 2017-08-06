# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="libhal stub forwarding to UDisks for Adobe Flash to play DRM content"
HOMEPAGE="https://github.com/cshorler/hal-flash https://build.opensuse.org/package/show/devel:openSUSE:Factory/hal-flash"
SRC_URI="https://github.com/cshorler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="sys-apps/dbus
	!sys-apps/hal"
RDEPEND="${COMMON_DEPEND}
	sys-fs/udisks"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

DOCS="README"

src_prepare() {
	eautoreconf; eapply_user;
}

src_install() {
	default
	prune_libtool_files
}
