# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit eutils

DESCRIPTION="A library for changing configuration files"
HOMEPAGE="http://augeas.net/"
SRC_URI="http://augeas.net/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ~ppc64 sparc x86"
IUSE="static-libs test"

RDEPEND="sys-libs/readline
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=app-doc/NaturalDocs-1.40
	test? ( dev-lang/ruby )"

src_prepare() {
	if [ -f /usr/share/NaturalDocs/Config/Languages.txt ] ; then
		addwrite /usr/share/NaturalDocs/Config/Languages.txt
	fi
	if [ -f /usr/share/NaturalDocs/Config/Topics.txt ] ; then
		addwrite /usr/share/NaturalDocs/Config/Topics.txt
	fi
}

src_configure() {
	econf $(use_enable static-libs static) || die
}

src_install() {
	default

	use static-libs || find "${ED}" -name '*.la' -delete

	dodoc AUTHORS ChangeLog README NEWS
}
