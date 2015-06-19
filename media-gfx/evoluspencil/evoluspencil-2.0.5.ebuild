# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/evoluspencil/evoluspencil-2.0.5.ebuild,v 1.3 2014/08/10 21:14:08 slyfox Exp $

EAPI=5
MY_P="pencil-${PV}"

inherit fdo-mime

DESCRIPTION="A simple GUI prototyping tool to create mockups"
HOMEPAGE="http://pencil.evolus.vn/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="|| ( www-client/firefox www-client/firefox-bin )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# avoid file collisions with media-gfx/pencil
	mv usr/bin/{pencil,${PN}} || die
	mv usr/share/{pencil,${PN}} || die
	mv usr/share/applications/{pencil,${PN}}.desktop || die

	sed -e "s/pencil/${PN}/" -i usr/bin/${PN} \
		-i usr/share/applications/${PN}.desktop || die
}

src_install() {
	doins -r usr
	newbin "${FILESDIR}"/launcher ${PN}
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
