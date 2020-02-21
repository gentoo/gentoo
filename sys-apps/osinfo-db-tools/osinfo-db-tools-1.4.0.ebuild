# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2

DESCRIPTION="Tools for managing the osinfo database"
HOMEPAGE="https://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

# Blocker on old libosinfo as osinfo-db-validate was part of it before
RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.6.0
	>=app-arch/libarchive-3.0.0:=
	dev-libs/json-glib
	!<sys-libs/libosinfo-1.0.0
"
# perl dep is for pod2man (and syntax check but only in git, but configure check exists in release)
# libxslt is checked for in configure.ac, but never used in 1.1.0
DEPEND="${RDEPEND}
	>=dev-libs/libxslt-1.0.0
	virtual/pkgconfig
	>=sys-devel/gettext-0.19.8
	dev-lang/perl
"
