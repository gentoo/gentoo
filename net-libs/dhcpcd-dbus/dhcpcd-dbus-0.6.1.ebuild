# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="DBus bindings for dhcpcd"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd-dbus/"
SRC_URI="http://roy.marples.name/downloads/dhcpcd/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/dbus"
RDEPEND="${DEPEND}
	>=net-misc/dhcpcd-5.0"

src_configure() {
	econf --localstatedir=/var
}
