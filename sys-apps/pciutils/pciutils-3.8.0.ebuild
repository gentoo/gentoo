# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal flag-o-matic

DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="https://mj.ucw.cz/sw/pciutils/ https://git.kernel.org/?p=utils/pciutils/pciutils.git"
SRC_URI="https://mj.ucw.cz/download/linux/pci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
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
BDEPEND="sys-apps/which
	kmod? ( virtual/pkgconfig )"

MULTILIB_WRAPPED_HEADERS=( /usr/include/pci/config.h )

switch_config() {
	[[ $# -ne 2 ]] && return 1
	local opt=$1 val=$2

	sed "s@^\(${opt}=\).*\$@\1${val}@" -i Makefile || die
	return 0
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
