# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils

DESCRIPTION="A libhal stub library forwarding to UDisks for www-plugins/adobe-flash to play DRM content"
HOMEPAGE="https://github.com/cshorler/hal-flash http://build.opensuse.org/package/show/devel:openSUSE:Factory/hal-flash"
SRC_URI="http://github.com/cshorler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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

src_prepare() { eautoreconf; eapply_user; }

src_install() {
        default
        prune_libtool_files
}
