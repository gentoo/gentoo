# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1 systemd

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="https://github.com/nhorman/rng-tools"
SRC_URI="https://github.com/nhorman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~mips ~ppc ppc64 ~riscv ~sparc ~x86"
IUSE="jitterentropy nistbeacon pkcs11 qrypt rtlsdr selinux test"
REQUIRED_USE="test? ( jitterentropy )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/openssl:=
	sys-libs/libcap
	jitterentropy? ( app-crypt/jitterentropy:= )
	nistbeacon? (
		dev-libs/jansson:=
		dev-libs/libxml2:2=
		net-misc/curl[ssl]
	)
	pkcs11? ( dev-libs/libp11:= )
	qrypt? (
		dev-libs/jansson:=
		net-misc/curl[ssl]
	)
	rtlsdr? ( net-wireless/rtl-sdr )
	elibc_musl? ( sys-libs/argp-standalone )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-rngd )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-6.16-c99.patch
)

src_prepare() {
	sed -i "s/sleep 30/sleep 120/g" tests/rngtestjitter.sh || die
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable jitterentropy)
		$(use_with nistbeacon)
		$(use_with pkcs11)
		$(use_with rtlsdr)
		$(use_with qrypt)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	RNGD_JITTER_TIMEOUT=90 default
}

src_install() {
	default

	newinitd "${FILESDIR}"/rngd-initd-6.11 rngd
	newconfd "${FILESDIR}"/rngd-confd-6.11 rngd
	systemd_dounit rngd.service

	if use pkcs11; then
		local DISABLE_AUTOFORMATTING=1
		local DOC_CONTENTS="
The PKCS11 entropy source may require extra packages (e.g. 'dev-libs/opensc')
to support various smartcard readers. Make sure 'PKCS11_OPTIONS' in:
	'${EPREFIX}/etc/conf.d/rngd'
reflects the correct PKCS11 engine path to be used by rngd.
"
		readme.gentoo_create_doc
	fi
}

pkg_postinst() {
	use pkcs11 && readme.gentoo_print_elog
}
