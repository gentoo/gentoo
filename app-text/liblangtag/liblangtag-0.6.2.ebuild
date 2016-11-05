# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils xdg-utils

DESCRIPTION="An interface library to access tags for identifying languages"
HOMEPAGE="https://tagoh.bitbucket.org/liblangtag/"
SRC_URI="https://bitbucket.org/tagoh/${PN}/downloads/${P}.tar.bz2"

LICENSE="|| ( LGPL-3 MPL-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="debug doc introspection static-libs test"

RDEPEND="
	dev-libs/libxml2
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection-common )
	test? ( dev-libs/check )
"

# Upstream expect liblangtag to be installed when one runs tests...
RESTRICT="test"

src_prepare() {
	default
	xdg_environment_reset
	if [[ -d docs/html ]]; then
		rm -r docs/html || die "Failed to remove existing gtk-doc"
	fi
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable doc gtk-doc) \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable test)
}

src_install() {
	default
	prune_libtool_files --all
}
