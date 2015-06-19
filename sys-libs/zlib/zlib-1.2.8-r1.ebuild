# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/zlib/zlib-1.2.8-r1.ebuild,v 1.13 2014/01/17 04:23:20 vapier Exp $

EAPI=4
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools toolchain-funcs multilib multilib-minimal

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="http://www.zlib.net/"
SRC_URI="http://zlib.net/${P}.tar.gz
	http://www.gzip.org/zlib/${P}.tar.gz
	http://www.zlib.net/current/beta/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="minizip static-libs"

DEPEND="minizip? ( ${AUTOTOOLS_DEPEND} )"
RDEPEND="abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
	!<dev-libs/libxml2-2.7.7" #309623

src_prepare() {
	if use minizip ; then
		cd contrib/minizip || die
		eautoreconf
	fi

	multilib_copy_sources
}

echoit() { echo "$@"; "$@"; }

multilib_src_configure() {
	case ${CHOST} in
	*-mingw*|mingw*)
		;;
	*)      # not an autoconf script, so can't use econf
		local uname=$("${EPREFIX}"/usr/share/gnuconfig/config.sub "${CHOST}" | cut -d- -f3) #347167
		echoit ./configure \
			--shared \
			--prefix="${EPREFIX}/usr" \
			--libdir="${EPREFIX}/usr/$(get_libdir)" \
			${uname:+--uname=${uname}} \
			|| die
		;;
	esac

	if use minizip ; then
		cd contrib/minizip || die
		econf $(use_enable static-libs static)
	fi
}

multilib_src_compile() {
	case ${CHOST} in
	*-mingw*|mingw*)
		emake -f win32/Makefile.gcc STRIP=true PREFIX=${CHOST}-
		sed \
			-e 's|@prefix@|${EPREFIX}/usr|g' \
			-e 's|@exec_prefix@|${prefix}|g' \
			-e 's|@libdir@|${exec_prefix}/'$(get_libdir)'|g' \
			-e 's|@sharedlibdir@|${exec_prefix}/'$(get_libdir)'|g' \
			-e 's|@includedir@|${prefix}/include|g' \
			-e 's|@VERSION@|'${PV}'|g' \
			zlib.pc.in > zlib.pc || die
		;;
	*)
		emake
		;;
	esac
	use minizip && emake -C contrib/minizip
}

sed_macros() {
	# clean up namespace a little #383179
	# we do it here so we only have to tweak 2 files
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' "$@" || die
}

multilib_src_install() {
	case ${CHOST} in
	*-mingw*|mingw*)
		emake -f win32/Makefile.gcc install \
			BINARY_PATH="${ED}/usr/bin" \
			LIBRARY_PATH="${ED}/usr/$(get_libdir)" \
			INCLUDE_PATH="${ED}/usr/include" \
			SHARED_MODE=1
		insinto /usr/share/pkgconfig
		doins zlib.pc
		;;

	*)
		emake install DESTDIR="${D}" LDCONFIG=:
		gen_usr_ldscript -a z
		;;
	esac
	sed_macros "${ED}"/usr/include/*.h

	if use minizip ; then
		emake -C contrib/minizip install DESTDIR="${D}"
		sed_macros "${ED}"/usr/include/minizip/*.h
	fi

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/lib{z,minizip}.{a,la} #419645
}

multilib_src_install_all() {
	dodoc FAQ README ChangeLog doc/*.txt
	use minizip && dodoc contrib/minizip/*.txt
}
