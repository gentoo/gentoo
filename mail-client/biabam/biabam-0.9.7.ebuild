# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Biabam is a small commandline tool for sending mail attachments"
HOMEPAGE="http://www.mmj.dk/biabam/"
SRC_URI="http://www.mmj.dk/biabam/${P}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-arch/sharutils
	app-shells/bash
	sys-apps/file
	virtual/mta"

src_install() {
	dodoc COPYING README
	dobin biabam
}
