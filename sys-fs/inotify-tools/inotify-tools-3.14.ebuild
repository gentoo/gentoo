# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="a set of command-line programs providing a simple interface to inotify"
HOMEPAGE="https://github.com/rvoicilas/inotify-tools/wiki"
SRC_URI="https://github.com/downloads/rvoicilas/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ~sparc x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

src_prepare() {
	default
	# timestamps are busted in tarball
	find . -type f -exec touch -r configure {} +
}

src_configure() {
	# only docs installed are doxygen ones, so use /html
	econf \
		--docdir='$(datarootdir)'/doc/${PF}/html \
		$(use_enable doc doxygen)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README NEWS AUTHORS ChangeLog
}
