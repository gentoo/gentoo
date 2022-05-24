# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal flag-o-matic

DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="https://mj.ucw.cz/sw/pciutils/ https://git.kernel.org/?p=utils/pciutils/pciutils.git"
SRC_URI="https://mj.ucw.cz/download/linux/pci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="dns +kmod static-libs +udev zlib"
REQUIRED_USE="static-libs? ( !udev )"

# Have the sub-libs in RDEPEND with [static-libs] since, logically,
# our libpci.a depends on libz.a/etc... at runtime.
LIB_DEPEND="zlib? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+),${MULTILIB_USEDEP}] )"
DEPEND="kmod? ( sys-apps/kmod )
	udev? ( >=virtual/libudev-208[${MULTILIB_USEDEP}] )
	static-libs? ( ${LIB_DEPEND} )
	!static-libs? ( ${LIB_DEPEND//static-libs([+-]),} )"
RDEPEND="${DEPEND}
	sys-apps/hwdata"
# See bug #847133 re binutils check
BDEPEND="sys-apps/which
	|| ( >=sys-devel/binutils-2.37:* sys-devel/lld sys-devel/native-cctools )
	kmod? ( virtual/pkgconfig )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/pci/config.h )

switch_config() {
	[[ $# -ne 2 ]] && return 1
	local opt=$1 val=$2

	sed "s@^\(${opt}=\).*\$@\1${val}@" -i Makefile || die
	return 0
}

check_binutils_version() {
	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]] && ! tc-ld-is-gold && ! tc-ld-is-lld ; then
		# Okay, hopefully it's Binutils' bfd.
		# bug #847133

		# Convert this:
		# ```
		# GNU ld (Gentoo 2.38 p4) 2.38
		# Copyright (C) 2022 Free Software Foundation, Inc.
		# This program is free software; you may redistribute it under the terms of
		# the GNU General Public License version 3 or (at your option) a later version.
		# This program has absolutely no warranty.
		# ```
		#
		# into...
		# ```
		# 2.38
		# ```
		local ver=$($(tc-getLD) --version 2>&1 | head -1 | rev | cut -d' ' -f1 | rev)
		ver_major=$(ver_cut 1 "${ver}")
		ver_minor=$(ver_cut 2 "${ver}")

		if [[ ${ver_major} -eq 2 && ${ver_minor} -lt 37 ]] ; then
			eerror "Old version of binutils activated! ${P} cannot be built with an old version."
			eerror "Please follow these steps:"
			eerror "1. Select a newer binutils (>= 2.37) using binutils-config"
			eerror "2. Run: . /etc/profile"
			eerror "3. Try emerging again with: emerge -v1 ${CATEGORY}/${P}"
			eerror "4. Complete your world upgrade if you were performing one."
			eerror "4. Perform a depclean (emerge -acv)"
			eerror "\tYou MUST depclean after every world upgrade in future!"
			die "Old binutils found! Change to a newer ld using binutils-config (bug #847133)."
		fi
	fi
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && check_binutils_version
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && check_binutils_version
}

src_prepare() {
	default

	if use static-libs ; then
		cp -pPR "${S}" "${S}.static" || die
		mv "${S}.static" "${S}/static" || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	# bug #471102
	append-lfs-flags
}

pemake() {
	emake \
		HOST="${CHOST}" \
		CROSS_COMPILE="${CHOST}-" \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		RANLIB="$(tc-getRANLIB)" \
		DNS=$(usex dns) \
		IDSDIR='$(SHAREDIR)/hwdata' \
		MANDIR='$(SHAREDIR)/man' \
		PREFIX="${EPREFIX}/usr" \
		SHARED="yes" \
		STRIP="" \
		ZLIB=$(usex zlib) \
		PCI_COMPRESSED_IDS=0 \
		PCI_IDS=pci.ids \
		LIBDIR="\${PREFIX}/$(get_libdir)" \
		LIBKMOD=$(multilib_native_usex kmod) \
		HWDB=$(usex udev) \
		"$@"
}

multilib_src_compile() {
	pemake OPT="${CFLAGS}" all

	if use static-libs ; then
		pemake \
			-C "${BUILD_DIR}"/static \
			OPT="${CFLAGS}" \
			SHARED="no" \
			lib/libpci.a
	fi
}

multilib_src_install() {
	pemake DESTDIR="${D}" install install-lib

	use static-libs && dolib.a "${BUILD_DIR}"/static/lib/libpci.a
}

multilib_src_install_all() {
	dodoc ChangeLog README TODO

	rm "${ED}"/usr/sbin/update-pciids "${ED}"/usr/share/man/man8/update-pciids.8* || die
	rm -r "${ED}"/usr/share/hwdata || die

	newinitd "${FILESDIR}"/init.d-pciparm pciparm
	newconfd "${FILESDIR}"/conf.d-pciparm pciparm
}
