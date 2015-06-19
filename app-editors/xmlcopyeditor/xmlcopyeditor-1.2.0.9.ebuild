# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/xmlcopyeditor/xmlcopyeditor-1.2.0.9.ebuild,v 1.3 2013/04/06 05:54:59 pinkbyte Exp $

EAPI="4"

WX_GTK_VER="2.8"

inherit autotools eutils wxwidgets

DESCRIPTION="XML Copy Editor is a fast, free, validating XML editor"
HOMEPAGE="http://xml-copy-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/xml-copy-editor/${P}.tar.gz
	guidexml? ( mirror://gentoo/GuideXML-templates.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="aqua guidexml"

RDEPEND="app-text/aspell
	>=dev-libs/libxml2-2.7.3-r1
	dev-libs/libxslt
	dev-libs/xerces-c[icu]
	dev-libs/libpcre
	!aqua? ( x11-libs/wxGTK:2.8[X] )
	aqua? ( x11-libs/wxGTK:2.8[aqua] )"
DEPEND="${RDEPEND}
	dev-libs/boost"

DOCS=( AUTHORS ChangeLog README NEWS )

src_prepare() {
	# fix desktop file
	sed -i  -e '/Categories/s/Application;//' \
		-e '/Icon/s/.png//' \
		"src/${PN}.desktop" || die "sed on src/${PN}.desktop failed"
	# bug #440744
	sed -i  -e 's/ -Wall -g -fexceptions//g' \
		-e '/CXXFLAGS/s/CPPFLAGS/CXXFLAGS/' \
		configure.in || die 'sed on configure.in failed'
	# bug #464280
	epatch "${FILESDIR}/${PN}-1.2.0.6-gcc-4.8.patch"

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install

	if use guidexml; then
		insinto /usr/share/xmlcopyeditor/templates/
		for TEMPLATE in "${WORKDIR}"/GuideXML-templates/*.xml; do
			newins "${TEMPLATE}" "${TEMPLATE##*/}"
		done
	fi

}
