# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="https://github.com/nhorman/rng-tools"
SRC_URI="https://github.com/nhorman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 ~riscv x86"
IUSE="jitterentropy nistbeacon pkcs11 selinux"

DEPEND="dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	sys-fs/sysfsutils
	jitterentropy? (
		app-crypt/jitterentropy:=
	)
	nistbeacon? (
		net-misc/curl[ssl]
		dev-libs/libxml2:2=
		dev-libs/openssl:0=
	)
	pkcs11? (
		dev-libs/libp11:=
	)
	elibc_musl? ( sys-libs/argp-standalone )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-rngd )"
DEPEND="${DEPEND}
	nistbeacon? (
		virtual/pkgconfig
	)
"

PATCHES=(
	"${FILESDIR}"/test-for-argp.patch
	"${FILESDIR}"/${PN}-5-fix-textrels-on-PIC-x86.patch #469962
	"${FILESDIR}"/rngd-shutdown.patch
)

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am || die

	# rngd_pkcs11.c needs to be linked against -lcrypto #684228
	# See: https://github.com/nhorman/rng-tools/pull/61
	if use pkcs11; then
		sed -e '/rngd_pkcs11.c$/ a rngd_LDADD\t+= -lcrypto' \
			-i Makefile.am || die
	fi

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
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}"/rngd-initd-6.7-r1 rngd
	newconfd "${FILESDIR}"/rngd-confd-6.7 rngd
	systemd_dounit "${FILESDIR}"/rngd.service

	if use pkcs11; then
		local DISABLE_AUTOFORMATTING=1
		local DOC_CONTENTS="
The PKCS11 entropy source may require extra packages (e.g. 'dev-libs/opensc')
to support various smartcard readers. Make sure 'PKCS11_OPTIONS' in:
	'${EROOT%/}/etc/conf.d/rngd'
reflects the correct PKCS11 engine path to be used by rngd.
"
		readme.gentoo_create_doc
	fi

}

pkg_postinst() {
	use pkcs11 && readme.gentoo_print_elog
}
