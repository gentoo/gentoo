# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/cpdvd/cpdvd-1.10-r1.ebuild,v 1.5 2012/03/06 20:54:16 ranger Exp $

EAPI=2

IUSE=""

S="${WORKDIR}"

DESCRIPTION="transfer a DVD title to your harddisk with ease on Linux"
HOMEPAGE="http://www.lallafa.de/bp/cpdvd.html"
SRC_URI="http://www.lallafa.de/bp/files/${P}.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND=""

RDEPEND=">=media-video/transcode-0.6.2[dvd]
	>=dev-lang/perl-5.8.0-r12
	>=media-video/cpvts-1.2"

src_install () {
	newbin ${P} ${PN} || die
}
