# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="XSL stylesheets for yelp"
HOMEPAGE="https://gitlab.gnome.org/GNOME/yelp-xsl"

LICENSE="GPL-2+ LGPL-2.1+ MIT FDL-1.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/libxml2-2.6.12:=
	>=dev-libs/libxslt-1.1.8:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/itstool-1.2.0
	>=sys-devel/gettext-0.19.8
	virtual/awk
	virtual/pkgconfig
"
