# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Library for handling Metalink files"
HOMEPAGE="https://launchpad.net/libmetalink"
SRC_URI="https://launchpad.net/${PN}/trunk/${P}/+download/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86"
IUSE="expat static-libs test xml"

RDEPEND="expat? ( dev-libs/expat )
	 xml? ( >=dev-libs/libxml2-2.6.24 )"
DEPEND="${RDEPEND}
	test? ( dev-util/cunit )"

REQUIRED_USE="^^ ( expat xml )"

src_configure() {
	econf \
		$(use_with expat libexpat) \
		$(use_with xml libxml2) \
		$(use_enable static-libs static)
}
