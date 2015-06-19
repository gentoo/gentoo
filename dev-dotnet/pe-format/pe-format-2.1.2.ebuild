# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/pe-format/pe-format-2.1.2.ebuild,v 1.6 2014/07/06 13:17:51 mgorny Exp $

EAPI=4

inherit autotools-utils fdo-mime systemd

DESCRIPTION="Intelligent PE executable wrapper for binfmt_misc"
HOMEPAGE="https://bitbucket.org/mgorny/pe-format2/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}2/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="!<sys-apps/openrc-0.9.4"

src_configure() {
	local myeconfargs=(
		"$(systemd_with_unitdir)"
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	keepdir /var/lib
}

pkg_postinst() {
	ebegin "Calling pe-format2-setup to update handler setup"
	pe-format2-setup
	eend ${?}

	fdo-mime_desktop_database_update
}
