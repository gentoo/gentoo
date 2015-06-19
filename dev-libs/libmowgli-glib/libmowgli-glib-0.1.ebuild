# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmowgli-glib/libmowgli-glib-0.1.ebuild,v 1.2 2012/05/08 07:03:04 jdhore Exp $

EAPI=4

DESCRIPTION="GLib bridge for libmowgli-2 eventing"
HOMEPAGE="http://github.com/nenolod/libmowgli-glib"
SRC_URI="http://tortois.es/~nenolod/distfiles/${P}.tar.bz2"
IUSE=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="dev-libs/glib:2
		dev-libs/libmowgli:2"
DEPEND="${RDEPEND}
		virtual/pkgconfig"
DOCS="README.md"
