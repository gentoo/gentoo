# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal toolchain-funcs

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}

MANUAL_PV=${MY_PV}
MANUAL_PV=6.2.1

MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}

DESCRIPTION="Library for arbitrary-precision arithmetic on different type of numbers"
HOMEPAGE="https://gmplib.org/"
SRC_URI="ftp://ftp.gmplib.org/pub/${MY_P}/${MY_P}.tar.xz
	mirror://gnu/${PN}/${MY_P}.tar.xz
	doc? ( https://gmplib.org/${PN}-man-${MANUAL_PV}.pdf )"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-arm64-darwin.patch.bz2"
S="${WORKDIR}"/${MY_P%a}

LICENSE="|| ( LGPL-3+ GPL-2+ )"
# The subslot reflects the C & C++ SONAMEs.
SLOT="0/10.4"
# Unkeyworded temporarily for some more testing
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+asm doc +cxx pic static-libs"

BDEPEND="
	app-arch/xz-utils
	sys-devel/m4
"

DOCS=( AUTHORS ChangeLog NEWS README doc/configuration doc/isa_abi_headache )
HTML_DOCS=( doc )

MULTILIB_WRAPPED_HEADERS=( /usr/include/gmp.h )

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.0-noexecstack-detect.patch
	"${FILESDIR}"/${PN}-6.2.1-no-zarch.patch
	"${WORKDIR}"/${P}-arm64-darwin.patch
	"${FILESDIR}"/${P}-CVE-2021-43618.patch
)

src_prepare() {
	default

	# We cannot run autotools here as gcc depends on this package
	elibtoolize

	# bug #536894
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

	tc-export CC

	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"

		--localstatedir="${EPREFIX}"/var/state/gmp
		--enable-shared

		# fat is needed to avoid gmp installing either purely generic
		# or specific-to-used-CPU (which our config.guess refresh prevents at the moment).
		# Both Fedora and opensuse use this option to tackle the issue, bug #883201.
		#
		# This only works for x86, so we're still getting non-performant
		# builds on other arches until we figure something out!
		$(use_enable asm fat)
		$(use_enable asm assembly)
		$(use_enable cxx)
		$(use_enable static-libs static)

		# --with-pic forces static libraries to be built as PIC
		# and without TEXTRELs. musl does not support TEXTRELs: bug #707332
		$(use pic && echo --with-pic)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# Should be a standalone lib
	rm -f "${ED}"/usr/$(get_libdir)/libgmp.la

	# This requires libgmp
	local la="${ED}/usr/$(get_libdir)/libgmpxx.la"
	if ! use static-libs ; then
		rm -f "${la}" || die
	fi
}

multilib_src_install_all() {
	einstalldocs
	use doc && cp "${DISTDIR}"/gmp-man-${MANUAL_PV}.pdf "${ED}"/usr/share/doc/${PF}/
}
