# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs multilib-minimal flag-o-matic

DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="https://mj.ucw.cz/sw/pciutils/ https://git.kernel.org/?p=utils/pciutils/pciutils.git"
SRC_URI="https://mj.ucw.cz/download/linux/pci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="dns +kmod static-libs +udev zlib"

# Have the sub-libs in RDEPEND with [static-libs] since, logically,
# our libpci.a depends on libz.a/etc... at runtime.
LIB_DEPEND="
	zlib? ( >=sys-libs/zlib-1.2.8-r1[static-libs(+),${MULTILIB_USEDEP}] )
	udev? ( >=virtual/libudev-208[static-libs(-),${MULTILIB_USEDEP}] )
"
DEPEND="
	kmod? ( sys-apps/kmod )
	static-libs? ( ${LIB_DEPEND} )
	!static-libs? ( ${LIB_DEPEND//static-libs([+-]),} )
"
RDEPEND="
	${DEPEND}
	sys-apps/hwids
"
BDEPEND="kmod? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.9-static-pc.patch
)

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
	append-lfs-flags #471102
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
		IDSDIR='$(SHAREDIR)/misc' \
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
			-C "${BUILD_DIR}/static" \
			OPT="${CFLAGS}" \
			SHARED="no" \
			lib/libpci.a
	fi
}

multilib_src_install() {
	pemake DESTDIR="${D}" install install-lib
	use static-libs && dolib.a "${BUILD_DIR}/static/lib/libpci.a"
}

multilib_src_install_all() {
	dodoc ChangeLog README TODO

	rm "${ED}"/usr/sbin/update-pciids "${ED}"/usr/share/misc/pci.ids \
		"${ED}"/usr/share/man/man8/update-pciids.8*

	newinitd "${FILESDIR}"/init.d-pciparm pciparm
	newconfd "${FILESDIR}"/conf.d-pciparm pciparm
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 3.2.0 ; then
		elog "The 'network-cron' USE flag is gone; if you want a more up-to-date"
		elog "pci.ids file, you should use sys-apps/hwids-99999999 (live ebuild)."
	fi
}
