# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="https://github.com/nhorman/rng-tools"
SRC_URI="https://github.com/nhorman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="jitterentropy libressl nistbeacon pkcs11 selinux"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-fs/sysfsutils
	jitterentropy? (
		app-crypt/jitterentropy:=
	)
	nistbeacon? (
		dev-libs/jansson
		dev-libs/libxml2:2=
		net-misc/curl[ssl]
	)
	pkcs11? (
		dev-libs/libp11:=
	)
	elibc_musl? ( sys-libs/argp-standalone )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-rngd )"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am || die

	default

	mv README.md README || die

	eautoreconf

	sed -i '/^AR /d' Makefile.in || die
	tc-export AR
}

src_configure() {
	local myeconfargs=(
		$(use_enable jitterentropy)
		$(use_with nistbeacon)
		$(use_with pkcs11)
		--without-rtlsdr # no librtlsdr in the tree
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}"/rngd-initd-6.11 rngd
	newconfd "${FILESDIR}"/rngd-confd-6.11 rngd
	systemd_dounit "${S}"/rngd.service

	if use pkcs11; then
		local DISABLE_AUTOFORMATTING=1
		local DOC_CONTENTS="
The PKCS11 entropy source may require extra packages (e.g. 'dev-libs/opensc')
to support various smartcard readers. Make sure 'PKCS11_OPTIONS' in:
	'${EROOT}/etc/conf.d/rngd'
reflects the correct PKCS11 engine path to be used by rngd.
"
		readme.gentoo_create_doc
	fi

}

pkg_postinst() {
	use pkcs11 && readme.gentoo_print_elog
}
