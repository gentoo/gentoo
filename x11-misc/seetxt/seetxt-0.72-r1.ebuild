# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Clever, lightweight GUI text file and manual page viewer for X windows"
HOMEPAGE="http://code.google.com/p/seetxt/ http://seetxt.sourceforge.net/"
SRC_URI="http://seetxt.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}/${PV}-0001-fix-linking.patch" \
		"${FILESDIR}/${PV}-0002-fix-shared-files-install.patch"
	eautoreconf
}

src_install() {
	dodir /usr/share/man/man1
	default
	sed -i -e 's|local/||' "${D}/usr/share/seetxt-runtime/filelist" || die "sed failed"
}
