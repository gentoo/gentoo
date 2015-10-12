# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vcs-snapshot autotools

DESCRIPTION="Provides a daemon for managing internet connections"
HOMEPAGE="https://github.com/connectivity/connman-gnome"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
	>=sys-apps/dbus-1.2
	>=dev-libs/dbus-glib-0.73
	>=x11-libs/gtk+-2.10:2
	>=net-misc/connman-1.0"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-lang/perl-5.8.1"

src_prepare() {
	eautoreconf
}
