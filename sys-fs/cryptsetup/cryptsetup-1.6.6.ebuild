# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit autotools python-single-r1 linux-info libtool eutils versionator

DESCRIPTION="Tool to setup encrypted devices with dm-crypt"
HOMEPAGE="https://code.google.com/p/cryptsetup/"
SRC_URI="https://cryptsetup.googlecode.com/files/${P}.tar.xz"
SRC_URI="mirror://kernel/linux/utils/${PN}/v$(get_version_component_range 1-2)/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
CRYPTO_BACKENDS="+gcrypt kernel nettle openssl"
# we don't support nss since it doesn't allow cryptsetup to be built statically
# and it's missing ripemd160 support so it can't provide full backward compatibility
IUSE="${CRYPTO_BACKENDS} nls pwquality python reencrypt static static-libs udev urandom"
REQUIRED_USE="^^ ( ${CRYPTO_BACKENDS//+/} )
	python? ( ${PYTHON_REQUIRED_USE} )
	static? ( !gcrypt )" #496612

LIB_DEPEND="dev-libs/libgpg-error[static-libs(+)]
	dev-libs/popt[static-libs(+)]
	sys-apps/util-linux[static-libs(+)]
	gcrypt? ( dev-libs/libgcrypt:0=[static-libs(+)] )
	nettle? ( >=dev-libs/nettle-2.4[static-libs(+)] )
	openssl? ( dev-libs/openssl[static-libs(+)] )
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

pkg_setup() {
	local CONFIG_CHECK="~DM_CRYPT ~CRYPTO ~CRYPTO_CBC"
	local WARNING_DM_CRYPT="CONFIG_DM_CRYPT:\tis not set (required for cryptsetup)\n"
	local WARNING_CRYPTO_CBC="CONFIG_CRYPTO_CBC:\tis not set (required for kernel 2.6.19)\n"
	local WARNING_CRYPTO="CONFIG_CRYPTO:\tis not set (required for cryptsetup)\n"
	check_extra_config

	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i '/^LOOPDEV=/s:$: || exit 0:' tests/{compat,mode}-test || die
	epatch_user && eautoreconf
}

src_configure() {
	if use kernel ; then
		ewarn "Note that kernel backend is very slow for this type of operation"
		ewarn "and is provided mainly for embedded systems wanting to avoid"
		ewarn "userspace crypto libraries."
	fi

	econf \
		--sbindir=/sbin \
		--enable-shared \
		$(use_enable static static-cryptsetup) \
		$(use_enable static-libs static) \
		$(use_enable nls) \
		$(use_enable pwquality) \
		$(use_enable python) \
		$(use_enable reencrypt cryptsetup-reencrypt) \
		$(use_enable udev) \
		$(use_enable !urandom dev-random) \
		--with-crypto_backend=$(for x in ${CRYPTO_BACKENDS//+/}; do use ${x} && echo ${x} ; done)
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

	newconfd "${FILESDIR}"/1.0.6-dmcrypt.confd dmcrypt
	newinitd "${FILESDIR}"/1.5.1-dmcrypt.rc dmcrypt
}

pkg_postinst() {
	if use gcrypt ; then
		elog "If you were using the whirlpool hash with libgcrypt, you might be impacted"
		elog "by broken code in <libgcrypt-1.6.0 versions.  See this page for more details:"
		elog "https://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions#8._Issues_with_Specific_Versions_of_cryptsetup"
	fi

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Please see the example for configuring a LUKS mountpoint"
		elog "in /etc/conf.d/dmcrypt"
		elog
		elog "If you are using baselayout-2 then please do:"
		elog "rc-update add dmcrypt boot"
		elog "This version introduces a command line arguement 'key_timeout'."
		elog "If you want the search for the removable key device to timeout"
		elog "after 10 seconds add the following to your bootloader config:"
		elog "key_timeout=10"
		elog "A timeout of 0 will mean it will wait indefinitely."
		elog
		elog "Users using cryptsetup-1.0.x (dm-crypt plain) volumes must use"
		elog "a compatibility mode when using cryptsetup-1.1.x. This can be"
		elog "done by specifying the cipher (-c), key size (-s) and hash (-h)."
		elog "For more info, see https://code.google.com/p/cryptsetup/wiki/FrequentlyAskedQuestions#6._Issues_with_Specific_Versions_of_cryptsetup"
	fi
}
