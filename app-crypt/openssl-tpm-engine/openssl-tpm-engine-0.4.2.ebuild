# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${P/-tpm-/_tpm_}"

DESCRIPTION="This provides a OpenSSL engine that uses private keys stored in TPM hardware"
HOMEPAGE="http://trousers.sourceforge.net"
SRC_URI="mirror://sourceforge/trousers/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"
RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	>=app-crypt/trousers-0.2.8"
DEPEND="${RDEPEND}"

DOCS=(
	openssl.cnf.sample
)

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
