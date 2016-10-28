# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="Documentation for developing for the GNOME desktop environment"
HOMEPAGE="https://developer.gnome.org/"

LICENSE="FDL-1.1+ CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xml-dtd:4.2
	app-text/yelp-tools
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_configure() {
	# Wants to build demo samples
	gnome2_src_configure ac_cv_path_CC=""
}
