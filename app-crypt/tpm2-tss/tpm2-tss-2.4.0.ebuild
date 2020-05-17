# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info tmpfiles udev

DESCRIPTION="TCG Trusted Platform Module 2.0 Software Stack"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tss"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc +fapi gcrypt +openssl static-libs test"

RESTRICT="!test? ( test )"

REQUIRED_USE="^^ ( gcrypt openssl )
		fapi? ( openssl !gcrypt )"

RDEPEND="acct-group/tss
	 acct-user/tss
	 fapi? (
		dev-libs/json-c
	        net-misc/curl
	 )
	 gcrypt? ( dev-libs/libgcrypt:0= )
	 openssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.0-fix-tmpfiles-path.patch"
	"${FILESDIR}/${PN}-2.4.0-Dont-run-systemd-sysusers-in-Makefile.patch"
	)

pkg_setup() {
	local CONFIG_CHECK=" \
		~TCG_TPM
	"
	linux-info_pkg_setup
	kernel_is ge 4 12 0 || ewarn "At least kernel 4.12.0 is required"
}

src_configure() {
	econf \
		$(use_enable doc doxygen-doc) \
		$(use_enable fapi) \
		$(use_enable static-libs static) \
		$(use_enable test unit) \
		--disable-tcti-mssim \
		--disable-defaultflags \
		--disable-weakcrypto \
		--with-crypto="$(usex gcrypt gcrypt ossl)" \
		--with-runstatedir=/run \
		--with-udevrulesdir="$(get_udevdir)/rules.d" \
		--with-udevrulesprefix=60- \
		--with-sysusersdir="/usr/lib/sysusers.d" \
		--with-tmpfilesdir="/usr/lib/tmpfiles.d"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	tmpfiles_process tpm2-tss-fapi.conf
}
