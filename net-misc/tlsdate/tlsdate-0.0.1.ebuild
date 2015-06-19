# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/tlsdate/tlsdate-0.0.1.ebuild,v 1.1 2012/09/09 05:53:37 vapier Exp $

EAPI="4"

inherit autotools vcs-snapshot flag-o-matic

DESCRIPTION="Update local time over HTTPS"
HOMEPAGE="https://github.com/ioerror/tlsdate"
SRC_URI="https://github.com/ioerror/tlsdate/tarball/${P} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -r '/^(C|LD)FLAGS/d' configure.ac || die
	eautoreconf
	append-cppflags "-DUNPRIV_GROUP='\"nobody\"'"
}
