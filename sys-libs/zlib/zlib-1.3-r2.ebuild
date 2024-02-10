# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Worth keeping an eye on 'develop' branch upstream for possible backports.
AUTOTOOLS_AUTO_DEPEND="no"
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/madler.asc
inherit autotools edo multilib-minimal flag-o-matic toolchain-funcs usr-ldscript verify-sig

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="https://zlib.net/"
SRC_URI="
	https://zlib.net/${P}.tar.xz
	https://zlib.net/fossils/${P}.tar.xz
	https://zlib.net/current/beta/${P}.tar.xz
	https://github.com/madler/zlib/releases/download/v${PV}/${P}.tar.xz
	verify-sig? (
		https://zlib.net/${P}.tar.xz.asc
		https://github.com/madler/zlib/releases/download/v${PV}/${P}.tar.xz.asc
	)
"

LICENSE="ZLIB"
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="minizip static-libs"

RDEPEND="!sys-libs/zlib-ng[compat]"
DEPEND="${RDEPEND}"
BDEPEND="
	minizip? ( ${AUTOTOOLS_DEPEND} )
	verify-sig? ( sec-keys/openpgp-keys-madler )
"

PATCHES=(
	# Don't install unexpected & unused crypt.h header (which would clash with other pkgs)
	# Pending upstream. bug #658536
	"${FILESDIR}"/${PN}-1.2.11-minizip-drop-crypt-header.patch

	# Respect AR, RANLIB, NM during build. Pending upstream. bug #831628
	"${FILESDIR}"/${PN}-1.2.11-configure-fix-AR-RANLIB-NM-detection.patch

	# Respect LDFLAGS during configure tests. Pending upstream
	"${FILESDIR}"/${PN}-1.2.13-use-LDFLAGS-in-configure.patch

	# Fix building on sparc with older binutils, we pass it in ebuild instead
	"${FILESDIR}"/${PN}-1.2.13-Revert-Turn-off-RWX-segment-warnings-on-sparc-system.patch

	# CVE-2023-45853 (bug #916484)
	"${FILESDIR}"/${PN}-1.2.13-CVE-2023-45853.patch
)

src_prepare() {
	default

	if use minizip ; then
		cd contrib/minizip || die
		eautoreconf
	fi

	case ${CHOST} in
		*-mingw*|mingw*)
			# Uses preconfigured Makefile rather than configure script
			multilib_copy_sources

			;;
	esac
}

multilib_src_configure() {
	# We pass manually instead of relying on the configure script/makefile
	# because it would pass it even for older binutils.
	use sparc && append-flags $(test-flags-CCLD -Wl,--no-warn-rwx-segments)

	# ideally we want !tc-ld-is-bfd for best future-proofing, but it needs
	# https://github.com/gentoo/gentoo/pull/28355
	# mold needs this too but right now tc-ld-is-mold is also not available
	if tc-ld-is-lld; then
		append-ldflags -Wl,--undefined-version
	fi

	case ${CHOST} in
		*-mingw*|mingw*)
			;;

		*)
			# bug #347167
			local uname=$("${BROOT}"/usr/share/gnuconfig/config.sub "${CHOST}" | cut -d- -f3)

			local myconf=(
				--shared
				--prefix="${EPREFIX}/usr"
				--libdir="${EPREFIX}/usr/$(get_libdir)"
				${uname:+--uname=${uname}}
			)

			# Not an autoconf script, so can't use econf
			edo "${S}"/configure "${myconf[@]}"

			;;
	esac

	if use minizip ; then
		local minizipdir="contrib/minizip"
		mkdir -p "${BUILD_DIR}/${minizipdir}" || die

		cd ${minizipdir} || die
		ECONF_SOURCE="${S}/${minizipdir}" econf $(use_enable static-libs static)
	fi
}

multilib_src_compile() {
	case ${CHOST} in
		*-mingw*|mingw*)
			emake -f win32/Makefile.gcc STRIP=true PREFIX=${CHOST}-
			sed \
				-e 's|@prefix@|'"${EPREFIX}"'/usr|g' \
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

multilib_src_install() {
	case ${CHOST} in
		*-mingw*|mingw*)
			emake -f win32/Makefile.gcc install \
				BINARY_PATH="${ED}/usr/bin" \
				LIBRARY_PATH="${ED}/usr/$(get_libdir)" \
				INCLUDE_PATH="${ED}/usr/include" \
				SHARED_MODE=1

			# Overwrites zlib.pc created from win32/Makefile.gcc, bug #620136
			insinto /usr/$(get_libdir)/pkgconfig
			doins zlib.pc

			;;

		*)
			emake install DESTDIR="${D}" LDCONFIG=:
			gen_usr_ldscript -a z

			;;
	esac

	if use minizip ; then
		emake -C contrib/minizip install DESTDIR="${D}"

		# This might not exist if slibtool is used.
		# bug #816756
		rm -f "${ED}"/usr/$(get_libdir)/libminizip.la || die
	fi

	if ! use static-libs ; then
		# bug #419645
		rm "${ED}"/usr/$(get_libdir)/libz.a || die
	fi
}

multilib_src_install_all() {
	dodoc FAQ README ChangeLog doc/*.txt

	if use minizip ; then
		dodoc contrib/minizip/*.txt
		doman contrib/minizip/*.1
	fi
}
