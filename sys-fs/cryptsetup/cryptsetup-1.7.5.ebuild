# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit autotools distutils-r1 linux-info libtool eutils versionator

DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="https://gitlab.com/cryptsetup/cryptsetup/blob/master/README.md"
SRC_URI="mirror://kernel/linux/utils/${PN}/v$(get_version_component_range 1-2)/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
CRYPTO_BACKENDS="+gcrypt kernel nettle openssl"
# we don't support nss since it doesn't allow cryptsetup to be built statically
# and it's missing ripemd160 support so it can't provide full backward compatibility
IUSE="${CRYPTO_BACKENDS} libressl nls pwquality python reencrypt static static-libs udev urandom"
REQUIRED_USE="^^ ( ${CRYPTO_BACKENDS//+/} )
	python? ( ${PYTHON_REQUIRED_USE} )
	static? ( !gcrypt )" #496612

LIB_DEPEND="dev-libs/libgpg-error[static-libs(+)]
	dev-libs/popt[static-libs(+)]
	sys-apps/util-linux[static-libs(+)]
	gcrypt? ( dev-libs/libgcrypt:0=[static-libs(+)] )
	nettle? ( >=dev-libs/nettle-2.4[static-libs(+)] )
	openssl? (
		!libressl? ( dev-libs/openssl:0=[static-libs(+)] )
		libressl? ( dev-libs/libressl:=[static-libs(+)] )
	)
	pwquality? ( dev-libs/libpwquality[static-libs(+)] )
	sys-fs/lvm2[static-libs(+)]
	udev? ( virtual/libudev[static-libs(+)] )"
# We have to always depend on ${LIB_DEPEND} rather than put behind
# !static? () because we provide a shared library which links against
# these other packages. #414665
RDEPEND="static-libs? ( ${LIB_DEPEND} )
	${LIB_DEPEND//\[static-libs\(+\)\]}
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	static? ( ${LIB_DEPEND} )"

#PATCHES=( )

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
	#epatch "${PATCHES[@]}"
	epatch_user && eautoreconf

	if use python ; then
		cd python
		cp "${FILESDIR}"/setup-1.7.0.py setup.py || die
		distutils-r1_src_prepare
	fi
}

src_configure() {
	if use kernel ; then
		ewarn "Note that kernel backend is very slow for this type of operation"
		ewarn "and is provided mainly for embedded systems wanting to avoid"
		ewarn "userspace crypto libraries."
	fi

	# We disable autotool python integration so we can use eclasses
	# for proper integration with multiple python versions.
	econf \
		--sbindir=/sbin \
		--enable-shared \
		--disable-python \
		$(use_enable static static-cryptsetup) \
		$(use_enable static-libs static) \
		$(use_enable nls) \
		$(use_enable pwquality) \
		$(use_enable reencrypt cryptsetup-reencrypt) \
		$(use_enable udev) \
		$(use_enable !urandom dev-random) \
		--with-crypto_backend=$(for x in ${CRYPTO_BACKENDS//+/} ; do usev ${x} ; done)

	use python && cd python && distutils-r1_src_configure
}

src_compile() {
	default
	use python && cd python && distutils-r1_src_compile
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
		use reencrypt && { mv "${ED}"/sbin/cryptsetup-reencrypt{.static,} || die ; }
	fi
	prune_libtool_files --modules

	newconfd "${FILESDIR}"/1.6.7-dmcrypt.confd dmcrypt
	newinitd "${FILESDIR}"/1.6.7-dmcrypt.rc dmcrypt

	use python && cd python && distutils-r1_src_install
}
