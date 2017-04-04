# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A lightweight, cross-platform IRC library"
HOMEPAGE="https://github.com/fstd/libsrsirc"
SRC_URI="http://penenen.de/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ssl"

DEPEND="
	ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_with ssl)
}
