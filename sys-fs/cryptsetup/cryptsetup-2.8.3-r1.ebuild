# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: meson (not just yet as of 2.8.0, see https://gitlab.com/cryptsetup/cryptsetup/-/issues/949#note_2585304492)
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/milanbroz.asc
inherit linux-info tmpfiles verify-sig

DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="https://gitlab.com/cryptsetup/cryptsetup"
SRC_URI="
	https://www.kernel.org/pub/linux/utils/${PN}/v$(ver_cut 1-2)/${P/_/-}.tar.xz
	verify-sig? ( https://www.kernel.org/pub/linux/utils/${PN}/v$(ver_cut 1-2)/${P/_/-}.tar.sign )
"
S="${WORKDIR}"/${P/_/-}

LICENSE="GPL-2+"
SLOT="0/12" # libcryptsetup.so version
if [[ ${PV} != *_rc* ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

CRYPTO_BACKENDS="gcrypt kernel nettle +openssl"
# we don't support nss since it doesn't allow cryptsetup to be built statically
# and it's missing ripemd160 support so it can't provide full backward compatibility
IUSE="${CRYPTO_BACKENDS} +argon2 fips nls pwquality passwdqc ssh static static-libs test +udev urandom"
RESTRICT="!test? ( test )"
# bug #496612, bug #832711, bug #843863
REQUIRED_USE="
	?? ( pwquality passwdqc )
	^^ ( ${CRYPTO_BACKENDS//+/} )
	static? ( !ssh !udev !fips )
	static-libs? ( !passwdqc )
	fips? ( !kernel !nettle )
"

LIB_DEPEND="
	dev-libs/json-c:=[static-libs(+)]
	dev-libs/popt[static-libs(+)]
	>=sys-apps/util-linux-2.31-r1[static-libs(+)]
	argon2? ( app-crypt/argon2:=[static-libs(+)] )
	gcrypt? (
		dev-libs/libgcrypt:0=[static-libs(+)]
		dev-libs/libgpg-error[static-libs(+)]
	)
	nettle? ( >=dev-libs/nettle-2.4[static-libs(+)] )
	openssl? ( dev-libs/openssl:0=[static-libs(+)] )
	pwquality? ( dev-libs/libpwquality[static-libs(+)] )
	passwdqc? ( sys-auth/passwdqc )
	ssh? ( net-libs/libssh[static-libs(+)] net-libs/libssh[sftp(+)] )
	sys-fs/lvm2[static-libs(+)]
"
# We have to always depend on ${LIB_DEPEND} rather than put behind
# !static? () because we provide a shared library which links against
# these other packages. bug #414665
RDEPEND="
	static-libs? ( ${LIB_DEPEND} )
	${LIB_DEPEND//\[static-libs\([+-]\)\]}
	udev? ( virtual/libudev:= )
"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
# vim-core needed for xxd in tests
BDEPEND="
	virtual/pkgconfig
	test? ( app-editors/vim-core )
	verify-sig? ( sec-keys/openpgp-keys-milanbroz )
"

PATCHES=(
	"${FILESDIR}/cryptsetup-2.8.3-bitlocker.patch"
)

pkg_setup() {
	local CONFIG_CHECK="~DM_CRYPT ~CRYPTO ~CRYPTO_CBC ~CRYPTO_SHA256"
	local WARNING_DM_CRYPT="CONFIG_DM_CRYPT:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_SHA256="CONFIG_CRYPTO_SHA256:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_CBC="CONFIG_CRYPTO_CBC:\tis not set (required for kernel 2.6.19)\n"
	local WARNING_CRYPTO="CONFIG_CRYPTO:\tis not set (required for cryptsetup)\n"
	check_extra_config
}

src_unpack() {
	if use verify-sig; then
		verify-sig_uncompress_verify_unpack "${DISTDIR}"/${P/_/-}.tar.xz \
			"${DISTDIR}"/${P/_/-}.tar.sign
	else
		default
	fi
}

src_prepare() {
	default

	sed -i '/^LOOPDEV=/s:$: || exit 0:' tests/{compat,mode}-test || die
}

src_configure() {
	local myeconfargs=(
		--disable-internal-argon2
		--disable-asciidoc
		--enable-shared
		--sbindir="${EPREFIX}"/sbin
		# for later use
		--with-default-luks-format=LUKS2
		--with-tmpfilesdir="${EPREFIX}/usr/lib/tmpfiles.d"
		--with-crypto_backend=$(for x in ${CRYPTO_BACKENDS//+/} ; do usev ${x} ; done)
		$(use_enable argon2 libargon2)
		$(use_enable nls)
		$(use_enable pwquality)
		$(use_enable passwdqc)
		$(use_enable !static external-tokens)
		$(use_enable static static-cryptsetup)
		$(use_enable static-libs static)
		$(use_enable udev)
		$(use_enable !urandom dev-random)
		$(use_enable ssh ssh-token)
		$(usev !argon2 '--with-luks2-pbkdf=pbkdf2')
		$(use_enable fips)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	if [[ ! -e /dev/mapper/control ]] ; then
		ewarn "No /dev/mapper/control found -- skipping tests"
		return 0
	fi

	local p
	for p in /dev/mapper /dev/loop* ; do
		addwrite ${p}
	done

	default
}

src_install() {
	default

	if use static ; then
		mv "${ED}"/sbin/cryptsetup{.static,} || die
		mv "${ED}"/sbin/veritysetup{.static,} || die
		mv "${ED}"/sbin/integritysetup{.static,} || die

		if use ssh ; then
			mv "${ED}"/sbin/cryptsetup-ssh{.static,} || die
		fi
	fi

	find "${ED}" -type f -name "*.la" -delete || die

	dodoc docs/v*ReleaseNotes

	newconfd "${FILESDIR}"/2.4.3-dmcrypt.confd dmcrypt
	newinitd "${FILESDIR}"/2.4.3-dmcrypt.rc dmcrypt
}

pkg_postinst() {
	tmpfiles_process cryptsetup.conf

	if use kernel ; then
		ewarn "Note that kernel backend is very slow for this type of operation"
		ewarn "and is provided mainly for embedded systems wanting to avoid"
		ewarn "userspace crypto libraries."
	fi
}
