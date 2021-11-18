# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info tmpfiles

DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="https://gitlab.com/cryptsetup/cryptsetup/blob/master/README.md"
SRC_URI="https://www.kernel.org/pub/linux/utils/${PN}/v$(ver_cut 1-2)/${P/_/-}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/12" # libcryptsetup.so version
[[ ${PV} != *_rc* ]] && \
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
CRYPTO_BACKENDS="gcrypt kernel nettle +openssl"
# we don't support nss since it doesn't allow cryptsetup to be built statically
# and it's missing ripemd160 support so it can't provide full backward compatibility
IUSE="${CRYPTO_BACKENDS} +argon2 nls pwquality reencrypt ssh static static-libs +udev urandom"
REQUIRED_USE="^^ ( ${CRYPTO_BACKENDS//+/} )
	static? ( !gcrypt !udev )" #496612

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
	ssh? ( net-libs/libssh[static-libs(+)] )
	sys-fs/lvm2[static-libs(+)]"
# We have to always depend on ${LIB_DEPEND} rather than put behind
# !static? () because we provide a shared library which links against
# these other packages. #414665
RDEPEND="static-libs? ( ${LIB_DEPEND} )
	${LIB_DEPEND//\[static-libs\([+-]\)\]}
	udev? ( virtual/libudev:= )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/${P/_/-}"

PATCHES=(
	"${FILESDIR}"/cryptsetup-2.4.1-external-tokens.patch
)

pkg_setup() {
	local CONFIG_CHECK="~DM_CRYPT ~CRYPTO ~CRYPTO_CBC ~CRYPTO_SHA256"
	local WARNING_DM_CRYPT="CONFIG_DM_CRYPT:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_SHA256="CONFIG_CRYPTO_SHA256:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_CBC="CONFIG_CRYPTO_CBC:\tis not set (required for kernel 2.6.19)\n"
	local WARNING_CRYPTO="CONFIG_CRYPTO:\tis not set (required for cryptsetup)\n"
	check_extra_config
}

src_prepare() {
	sed -i '/^LOOPDEV=/s:$: || exit 0:' tests/{compat,mode}-test || die
	default
}

src_configure() {
	if use kernel ; then
		ewarn "Note that kernel backend is very slow for this type of operation"
		ewarn "and is provided mainly for embedded systems wanting to avoid"
		ewarn "userspace crypto libraries."
	fi

	local myeconfargs=(
		--disable-internal-argon2
		--enable-shared
		--sbindir=/sbin
		# for later use
		--with-default-luks-format=LUKS2
		--with-tmpfilesdir="${EPREFIX}/usr/lib/tmpfiles.d"
		--with-crypto_backend=$(for x in ${CRYPTO_BACKENDS//+/} ; do usev ${x} ; done)
		$(use_enable argon2 libargon2)
		$(use_enable nls)
		$(use_enable pwquality)
		$(use_enable reencrypt cryptsetup-reencrypt)
		$(use_enable !static external-tokens)
		$(use_enable static static-cryptsetup)
		$(use_enable static-libs static)
		$(use_enable udev)
		$(use_enable !urandom dev-random)
		$(use_enable ssh ssh-token)
		$(usex argon2 '' '--with-luks2-pbkdf=pbkdf2')
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
		if use reencrypt ; then
			mv "${ED}"/sbin/cryptsetup-reencrypt{.static,} || die
		fi
	fi
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc docs/v*ReleaseNotes

	newconfd "${FILESDIR}"/2.4.0-dmcrypt.confd dmcrypt
	newinitd "${FILESDIR}"/2.4.0-dmcrypt.rc dmcrypt
}

pkg_postinst() {
	tmpfiles_process cryptsetup.conf
}
