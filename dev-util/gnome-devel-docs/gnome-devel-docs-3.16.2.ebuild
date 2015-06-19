# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnome-devel-docs/gnome-devel-docs-3.16.2.ebuild,v 1.1 2015/06/09 09:34:34 eva Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Documentation for developing for the GNOME desktop environment"
HOMEPAGE="http://developer.gnome.org/"

LICENSE="FDL-1.1+ CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xml-dtd:4.2
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig
"

# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_configure() {
	# Wants to build demo samples
	gnome2_src_configure ITSTOOL=$(type -P true) ac_cv_path_CC=""
}
