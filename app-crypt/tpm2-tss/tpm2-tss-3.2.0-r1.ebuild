# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info tmpfiles udev

DESCRIPTION="TCG Trusted Platform Module 2.0 Software Stack"
HOMEPAGE="https://github.com/tpm2-software/tpm2-tss"
SRC_URI="https://github.com/tpm2-software/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc +fapi +openssl mbedtls static-libs test"

RESTRICT="!test? ( test )"

REQUIRED_USE="^^ ( mbedtls openssl )
		fapi? ( openssl !mbedtls )"

RDEPEND="acct-group/tss
	acct-user/tss
	fapi? ( dev-libs/json-c:=
		>=net-misc/curl-7.80.0 )
	mbedtls? ( net-libs/mbedtls:= )
	openssl? ( dev-libs/openssl:= )"

DEPEND="${RDEPEND}
	test? ( app-crypt/swtpm
		dev-libs/uthash
		dev-util/cmocka
		fapi? ( >=net-misc/curl-7.80.0 ) )"
BDEPEND="sys-apps/acl
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0-Dont-run-systemd-sysusers-in-Makefile.patch"
)

pkg_setup() {
	local CONFIG_CHECK=" \
		~TCG_TPM
	"
	linux-info_pkg_setup
	kernel_is ge 4 12 0 || ewarn "At least kernel 4.12.0 is required"
}

src_prepare() {
	default

	# See bug #833887 (and similar); eautoreconf means .pc file gets wrong version.
	sed -i \
	"s/m4_esyscmd_s(\[git describe --tags --always --dirty\])/${PV}/" \
		"configure.ac" || die

	eautoreconf
}

src_configure() {
	econf \
		--localstatedir=/var \
		$(use_enable doc doxygen-doc) \
		$(use_enable fapi) \
		$(use_enable static-libs static) \
		$(use_enable test unit) \
		$(use_enable test integration) \
		$(use_enable test self-generated-certificate) \
		--disable-tcti-libtpms \
		--disable-defaultflags \
		--disable-weakcrypto \
		--with-crypto="$(usex mbedtls mbed ossl)" \
		--with-runstatedir=/run \
		--with-udevrulesdir="$(get_udevdir)/rules.d" \
		--with-udevrulesprefix=60- \
		--with-sysusersdir="/usr/lib/sysusers.d" \
		--with-tmpfilesdir="/usr/lib/tmpfiles.d"
}

src_install() {
	default

	if [[ ${PV} != $(sed -n -e 's/^Version: //p' "${ED}/usr/$(get_libdir)/pkgconfig/tss2-sys.pc" || die) ]] ; then
		# Safeguard for bug #833887
		die "pkg-config file version doesn't match ${PV}! Please report a bug!"
	fi

	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	tmpfiles_process tpm2-tss-fapi.conf
}
