# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Tools for managing the osinfo database"
HOMEPAGE="http://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

# Blocker on old libosinfo as osinfo-db-validate was part of it before
RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.6.0
	>=app-arch/libarchive-3.0.0:=
	!<sys-libs/libosinfo-1.0.0
"
# perl dep is for pod2man
# libxslt is checked for in configure.ac, but never used in 1.1.0
DEPEND="${RDEPEND}
	>=dev-libs/libxslt-1.0.0
	virtual/pkgconfig
	>=dev-util/intltool-0.40.0
	dev-lang/perl
"
