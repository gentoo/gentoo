# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libgnomemm/libgnomemm-2.30.0.ebuild,v 1.10 2013/04/09 16:41:19 ago Exp $

EAPI=4
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit gnome2

DESCRIPTION="C++ bindings for libgnome"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.8:2.4
	>=gnome-base/libgnome-2.6"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO"
