# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/guile-lib/guile-lib-0.1.3.ebuild,v 1.13 2010/09/23 23:51:17 chiiph Exp $

EAPI="3"

inherit eutils

DESCRIPTION="An accumulation place for pure-scheme Guile modules"
HOMEPAGE="http://www.nongnu.org/guile-lib/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ppc sparc x86"
IUSE=""

RDEPEND="dev-scheme/guile[regex,deprecated]"
DEPEND="${RDEPEND} !<dev-libs/g-wrap-1.9.8"

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
}
