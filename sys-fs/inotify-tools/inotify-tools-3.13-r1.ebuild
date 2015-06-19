# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/inotify-tools/inotify-tools-3.13-r1.ebuild,v 1.6 2014/01/05 15:17:48 polynomial-c Exp $

EAPI=5

DESCRIPTION="a set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/rvoicilas/inotify-tools/wiki"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	# timestamps are busted in tarball
	find . -type f -exec touch -r configure {} +
}

src_configure() {
	# only docs installed are doxygen ones, so use /html
	econf \
		--docdir=/usr/share/doc/${PF}/html \
		$(use_enable doc doxygen)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS AUTHORS ChangeLog
}
