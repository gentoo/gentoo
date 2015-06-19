# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmetalink/libmetalink-0.1.1.ebuild,v 1.7 2013/05/26 15:57:16 ago Exp $

EAPI="5"

DESCRIPTION="Library for handling Metalink files"
HOMEPAGE="http://launchpad.net/libmetalink"
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
