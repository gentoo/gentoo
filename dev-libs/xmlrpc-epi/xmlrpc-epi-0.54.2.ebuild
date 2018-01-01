# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Epinions implementation of XML-RPC protocol in C"
HOMEPAGE="http://xmlrpc-epi.sourceforge.net/"
SRC_URI="mirror://sourceforge/xmlrpc-epi/${P}.tar.bz2"

LICENSE="Epinions"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="static-libs"

DEPEND="dev-libs/expat:="
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.54.2-fix-build-system.patch )

src_configure() {
	# NOTES:
	# to prevent conflict with xmlrpc-c, headers are installed in
	# 	/usr/include/${PN} instead of /usr/include (bug 274291)
	econf \
		--includedir="${EPREFIX}"/usr/include/${PN} \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		# remove useless .la files
		find "${D}" -name '*.la' -delete || die
	fi

	docinto examples
	docompress -x /usr/share/doc/${PF}/examples
	dodoc sample/*.c sample/*.php
	dodoc -r sample/tests
}
