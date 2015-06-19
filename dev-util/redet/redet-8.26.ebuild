# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/redet/redet-8.26.ebuild,v 1.2 2012/09/05 07:48:29 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="A regular expression development and execution tool"
HOMEPAGE="http://www.billposer.org/Software/redet.html"

SRC_URI="http://www.billposer.org/Software/Downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/tk
	dev-tcltk/itk
	dev-tcltk/iwidgets"
RDEPEND="${DEPEND}"

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	local MANUAL_PN=`echo ${PN} | cut -c 1 | tr [:lower:] [:upper:]``echo ${PN} | cut -c 2-`

	newbin ${PN}.tcl ${PN}

	sed \
		-e "/Encoding/d" \
		-i ${PN}.desktop || die
	domenu ${PN}.desktop

	doman ${PN}.1 || die
	dodoc AUTHORS CREDITS README-General README-MacOSX \
	 SampleClasses.utf8 \
	 SampleCustomCharacterWidgetDefinition_Armenian \
	 SampleCustomCharacterWidgetDefinition_Greek \
	 SampleNewStyleDotRedetRC_Elaborate SampleNewStyleDotRedetRC_Simple
	dosym doc/${P}/html /usr/share/${MANUAL_PN}
}
