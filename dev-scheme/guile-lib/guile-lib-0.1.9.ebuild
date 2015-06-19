# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/guile-lib/guile-lib-0.1.9.ebuild,v 1.9 2013/05/25 07:46:02 ago Exp $

EAPI="3"

inherit eutils

DESCRIPTION="An accumulation place for pure-scheme Guile modules"
HOMEPAGE="http://www.nongnu.org/guile-lib/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-scheme/guile[regex,deprecated]"
DEPEND="${RDEPEND} !<dev-libs/g-wrap-1.9.8"

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
}
