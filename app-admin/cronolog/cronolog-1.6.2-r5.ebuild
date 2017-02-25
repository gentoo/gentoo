# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools

DESCRIPTION="Log rotation software"
HOMEPAGE="https://github.com/fordmason/cronolog"
SRC_URI="http://cronolog.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

PATCHES=(
	"${FILESDIR}"/${PV}-patches/${PN}-define-strptime.patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-doc.patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-getopt-long.patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-large-file-patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-missing-symlink-patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-setugid-patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-sigusr1-patch.txt
	"${FILESDIR}"/${PV}-patches/${PN}-strftime-patch.txt
	"${FILESDIR}"/${P}-umask.patch
)

DOCS=( AUTHORS ChangeLog INSTALL NEWS README TODO )

src_prepare() {
	default
	eautoreconf
}
