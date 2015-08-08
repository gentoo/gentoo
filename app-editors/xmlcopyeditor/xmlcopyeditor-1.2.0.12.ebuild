# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

WX_GTK_VER="2.8"

inherit autotools wxwidgets

DESCRIPTION="XML Copy Editor is a fast, free, validating XML editor"
HOMEPAGE="http://xml-copy-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/xml-copy-editor/${P}.tar.gz
	guidexml? ( mirror://gentoo/GuideXML-templates.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="aqua guidexml"

RDEPEND=">=dev-libs/libxml2-2.7.3-r1
	dev-libs/libxslt
	dev-libs/xerces-c[icu]
	dev-libs/libpcre
	app-text/aspell
	!aqua? ( x11-libs/wxGTK:2.8[X] )
	aqua? ( x11-libs/wxGTK:2.8[aqua] )"
DEPEND="${RDEPEND}
	dev-libs/boost"

DOCS=( AUTHORS ChangeLog README NEWS )

src_prepare() {
	# fix desktop file
	sed -i  -e '/Categories/s/Application;//' \
		-e '/Icon/s/.png//' \
		-e 's/\r//g' \
		"src/${PN}.desktop" || die "sed on src/${PN}.desktop failed"
	# bug #440744
	sed -i  -e 's/ -Wall -g -fexceptions//g' \
		-e '/CXXFLAGS/s/CPPFLAGS/CXXFLAGS/' \
		configure.ac || die 'sed on configure.ac failed'
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
