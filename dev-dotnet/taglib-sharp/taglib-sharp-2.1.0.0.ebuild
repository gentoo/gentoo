# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/taglib-sharp/taglib-sharp-2.1.0.0.ebuild,v 1.4 2012/12/07 04:54:12 phajdan.jr Exp $

EAPI=4

inherit mono

DESCRIPTION="Taglib# 2.0 - Managed tag reader/writer"
HOMEPAGE="http://download.banshee.fm/taglib-sharp/"
SRC_URI="http://download.banshee-project.org/${PN}/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-lang/mono"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	sed -i	-e "s:docs::" \
		-e "s:examples::" \
		Makefile.in || die "sedding sense into makefiles failed"
}

src_configure() {
	econf --disable-docs
}
