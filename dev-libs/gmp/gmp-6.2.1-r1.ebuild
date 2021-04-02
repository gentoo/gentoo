# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic eutils libtool multilib-minimal toolchain-funcs

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}
MANUAL_PV=$MY_PV
MANUAL_PV=6.2.0 # 6.2.1 manual is not ready yet
MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}
DESCRIPTION="Library for arbitrary-precision arithmetic on different type of numbers"
HOMEPAGE="https://gmplib.org/"
SRC_URI="ftp://ftp.gmplib.org/pub/${MY_P}/${MY_P}.tar.xz
	mirror://gnu/${PN}/${MY_P}.tar.xz
	doc? ( https://gmplib.org/${PN}-man-${MANUAL_PV}.pdf )"

LICENSE="|| ( LGPL-3+ GPL-2+ )"
# The subslot reflects the C & C++ SONAMEs.
SLOT="0/10.4"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+asm doc +cxx pic static-libs"

BDEPEND="sys-devel/m4
	app-arch/xz-utils"

S=${WORKDIR}/${MY_P%a}

DOCS=( AUTHORS ChangeLog NEWS README doc/configuration doc/isa_abi_headache )
HTML_DOCS=( doc )
MULTILIB_WRAPPED_HEADERS=( /usr/include/gmp.h )

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.0-noexecstack-detect.patch
	"${FILESDIR}"/${PN}-6.2.1-no-zarch.patch
)

src_prepare() {
	default

	# note: we cannot run autotools here as gcc depends on this package
	elibtoolize

	# https://bugs.gentoo.org/536894
	if [[ ${CHOST} == *-darwin* ]] ; then
		eapply "${FILESDIR}"/${PN}-6.1.2-gcc-apple-4.0.1.patch
	fi

	# GMP uses the "ABI" env var during configure as does Gentoo (econf).
	# So, to avoid patching the source constantly, wrap things up.
	mv configure configure.wrapped || die
	cat <<-\EOF > configure
	#!/usr/bin/env sh
	exec env ABI="${GMPABI}" "$0.wrapped" "$@"
	EOF
	# Patches to original configure might have lost the +x bit.
	chmod a+rx configure{,.wrapped} || die
}

multilib_src_configure() {
	# Because of our 32-bit userland, 1.0 is the only HPPA ABI that works
	# https://gmplib.org/manual/ABI-and-ISA.html#ABI-and-ISA (bug #344613)
	if [[ ${CHOST} == hppa2.0-* ]] ; then
		GMPABI="1.0"
	fi

	# ABI mappings (needs all architectures supported)
	case ${ABI} in
		32|x86)       GMPABI=32;;
		64|amd64|n64) GMPABI=64;;
		[onx]32)      GMPABI=${ABI};;
	esac
	export GMPABI

	#367719
	if [[ ${CHOST} == *-mint* ]]; then
		filter-flags -O?
	fi

	# --with-pic forces static libraries to be built as PIC
	# and without TEXTRELs. musl does not support TEXTRELs: bug #707332
	tc-export CC
	ECONF_SOURCE="${S}" econf \
		CC_FOR_BUILD="$(tc-getBUILD_CC)" \
		--localstatedir="${EPREFIX}"/var/state/gmp \
		--enable-shared \
		$(use_enable asm assembly) \
		$(use_enable cxx) \
		$(use pic && echo --with-pic) \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# should be a standalone lib
	rm -f "${ED}"/usr/$(get_libdir)/libgmp.la
	# this requires libgmp
	local la="${ED}/usr/$(get_libdir)/libgmpxx.la"
	use static-libs || rm -f "${la}"
}

multilib_src_install_all() {
	einstalldocs
	use doc && cp "${DISTDIR}"/gmp-man-${MANUAL_PV}.pdf "${ED}"/usr/share/doc/${PF}/
}
