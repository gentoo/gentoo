# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Remote procedure call package for IP/UDP (used by Coda)"
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/rpc2/src/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="static-libs"

RDEPEND=">=sys-libs/lwp-2.5"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dodoc README.ipv6
	use static-libs || find "${ED}"/usr -name '*.la' -delete
}
