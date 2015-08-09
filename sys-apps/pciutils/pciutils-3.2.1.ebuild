# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib toolchain-funcs

DESCRIPTION="Various utilities dealing with the PCI bus"
HOMEPAGE="http://mj.ucw.cz/sw/pciutils/ http://git.kernel.org/?p=utils/pciutils/pciutils.git"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="dns +kmod static-libs zlib"

# Have the sub-libs in RDEPEND with [static-libs] since, logically,
# our libssl.a depends on libz.a/etc... at runtime.
LIB_DEPEND="zlib? ( sys-libs/zlib[static-libs(+)] )"
DEPEND="kmod? ( sys-apps/kmod )
	static-libs? ( ${LIB_DEPEND} )
	!static-libs? ( ${LIB_DEPEND//\[static-libs(+)]} )"
RDEPEND="${DEPEND}
	sys-apps/hwids"
DEPEND="${DEPEND}
	kmod? ( virtual/pkgconfig )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.1.9-static-pc.patch

	if use static-libs ; then
		cp -pPR "${S}" "${S}.static" || die
	fi
}

pemake() {
	emake \
		HOST="${CHOST}" \
		CROSS_COMPILE="${CHOST}-" \
		CC="$(tc-getCC)" \
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
		LIBKMOD=$(usex kmod) \
		"$@"
}

src_compile() {
	pemake OPT="${CFLAGS}" all
	if use static-libs ; then
		pemake \
			-C "${S}.static" \
			OPT="${CFLAGS}" \
			SHARED="no" \
			lib/libpci.a
	fi
}

src_install() {
	pemake DESTDIR="${D}" install install-lib
	use static-libs && dolib.a "${S}.static/lib/libpci.a"
	dodoc ChangeLog README TODO

	rm "${ED}"/usr/sbin/update-pciids "${ED}"/usr/share/misc/pci.ids \
		"${ED}"/usr/share/man/man8/update-pciids.8*

	newinitd "${FILESDIR}"/init.d-pciparm pciparm
	newconfd "${FILESDIR}"/conf.d-pciparm pciparm
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} ]] && [[ ${REPLACING_VERSIONS} < 3.2.0 ]]; then
		elog "The 'network-cron' USE flag is gone; if you want a more up-to-date"
		elog "pci.ids file, you should use sys-apps/hwids-99999999 (live ebuild)."
	fi
}
