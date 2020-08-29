# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Condor's classified advertisement language"
HOMEPAGE="http://www.cs.wisc.edu/condor/classad/"
SRC_URI="ftp://ftp.cs.wisc.edu/condor/classad/c++/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcre"

RDEPEND="pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-namespace \
		--enable-flexible-member
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
