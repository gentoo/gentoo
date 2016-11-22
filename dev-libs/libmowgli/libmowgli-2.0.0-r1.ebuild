# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Useful set of performance and usability-oriented extensions to C"
HOMEPAGE="http://www.atheme.org/project/mowgli"
SRC_URI="http://atheme.org/downloads/${P}.tar.gz"
IUSE="libressl ssl"

LICENSE="BSD-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
RDEPEND="ssl? (
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
)"
DEPEND="${RDEPEND}"
DOCS="AUTHORS README doc/BOOST doc/design-concepts.txt"

src_configure() {
	# disabling SSL is "broken" in 2.0.0 so we have to use this hack till 2.0.1
	use !ssl && myconf="--with-openssl=/dev/null"
	econf ${myconf}
}
