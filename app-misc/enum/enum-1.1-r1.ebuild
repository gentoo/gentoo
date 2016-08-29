# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Replacement for GNU seq and BSD jot"
HOMEPAGE="https://fedorahosted.org/enum/"
SRC_URI="https://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	default

	# Remove bundled getopt
	rm -rv thirdparty || die
}

src_configure() {
	econf \
		--disable-doc-rebuild \
		--disable-dependency-tracking
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc ChangeLog
}
