# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library providing software emultion of a TPM"
HOMEPAGE="https://github.com/stefanberger/libtpms"
SRC_URI="https://github.com/stefanberger/libtpms/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl"

DEPEND=" !libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-tpm12-Initialize-some-variables-for-gcc.patch"
	"${FILESDIR}/${P}-tpm12-Fix-potential-buffer-overflow-in-filename-creation.patch"
	"${FILESDIR}/${P}-tpm12-Initialize-a-few-variables-for-x86-gcc-O3.patch"
	"${FILESDIR}/${P}-tpm2-Fix-a-gcc-10.1.0-complaint.patch"
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
	  --with-openssl \
	  --with-tpm2
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
