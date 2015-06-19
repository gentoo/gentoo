# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmowgli/libmowgli-2.0.0.ebuild,v 1.9 2013/07/17 20:36:15 pinkbyte Exp $

EAPI=4

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="http://www.atheme.org/project/mowgli"
SRC_URI="http://atheme.org/downloads/${P}.tar.gz"
IUSE="ssl"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
RDEPEND="ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}"
DOCS="AUTHORS README doc/BOOST doc/design-concepts.txt"

src_configure() {
	# disabling SSL is "broken" in 2.0.0 so we have to use this hack till 2.0.1
	use !ssl && myconf="--with-openssl=/dev/null"
	econf ${myconf}
}
