# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1

MY_PV="${PV/_/-}"

DESCRIPTION="OpenSSL Engine for TPM2 devices"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tools"
SRC_URI="https://github.com/tpm2-software/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-crypt/tpm2-tss
	dev-libs/openssl:0="
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="sys-devel/autoconf-archive
	virtual/pkgconfig"
S="${WORKDIR}/${PN}-${MY_PV}"

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
	dobashcomp bash-completion/*
}
