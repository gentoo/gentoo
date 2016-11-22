# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit xdg-utils eutils

DESCRIPTION="An interface library to access tags for identifying languages"
HOMEPAGE="https://tagoh.bitbucket.org/liblangtag/"
SRC_URI="https://bitbucket.org/tagoh/${PN}/downloads/${P}.tar.bz2"

LICENSE="|| ( LGPL-3 MPL-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="introspection static-libs test"

RDEPEND="
	dev-libs/libxml2
	introspection? ( >=dev-libs/gobject-introspection-0.10.8 )"
DEPEND="${RDEPEND}
	introspection? ( dev-libs/gobject-introspection-common )
	sys-devel/gettext
	test? ( dev-libs/check )
"

# Upstream expect liblangtag to be installed when one runs tests...
RESTRICT="test"

src_configure() {
	xdg_environment_reset
	econf \
		$(use_enable introspection) \
		$(use_enable test)
}

src_install() {
	default
	prune_libtool_files --all
}
