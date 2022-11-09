# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

DESCRIPTION="OpenSSL Engine for TPM2 devices"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tss-engine"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-crypt/tpm2-tss:=
	>=dev-libs/openssl-1.1.1:=
	<dev-libs/openssl-3.0.0:="
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="sys-devel/autoconf-archive
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.0-tests-Allow-compilation-under-musl.patch"
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable test unit) \
		--disable-defaultflags \
		--disable-static \
		--with-completionsdir="$(get_bashcompdir)"
}

src_install () {
	default
	find "${ED}" -name '*.la' -delete || die
	dobashcomp bash-completion/*
}
