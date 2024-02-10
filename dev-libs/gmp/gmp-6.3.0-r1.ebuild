# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnuconfig libtool flag-o-matic multilib-minimal toolchain-funcs

MY_PV=${PV/_p*}
MY_PV=${MY_PV/_/-}

MANUAL_PV=6.2.1

MY_P=${PN}-${MY_PV}
PLEVEL=${PV/*p}

DESCRIPTION="Library for arbitrary-precision arithmetic on different type of numbers"
HOMEPAGE="https://gmplib.org/"
SRC_URI="
	https://gmplib.org/download/gmp/${MY_P}.tar.xz
	mirror://gnu/${PN}/${MY_P}.tar.xz
	doc? ( https://gmplib.org/${PN}-man-${MANUAL_PV}.pdf )
"
S="${WORKDIR}"/${MY_P%a}

LICENSE="|| ( LGPL-3+ GPL-2+ )"
# The subslot reflects the C & C++ SONAMEs.
SLOT="0/10.4"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+asm doc +cpudetection +cxx pic static-libs"
REQUIRED_USE="cpudetection? ( asm )"
RESTRICT="!cpudetection? ( bindist )"

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
)

pkg_pretend() {
	if use cpudetection && ! use amd64 && ! use x86 ; then
		elog "Using generic C implementation on non-amd64/x86 with USE=cpudetection"
		elog "--enable-fat is a no-op on alternative arches."
		elog "To obtain an optimized build, set USE=-cpudetection, but binpkgs should not then be made."
	fi
}

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

	# Save the upstream files named config.{guess,sub} which are
	# wrappers around the gnuconfig versions.
	mkdir "${T}"/gmp-gnuconfig || die
	mv config.guess "${T}"/gmp-gnuconfig/config.guess || die
	mv config.sub "${T}"/gmp-gnuconfig/config.sub || die
	# Grab fresh copies from gnuconfig.
	touch config.guess config.sub || die
	gnuconfig_update
	# Rename the fresh copies to the filenames the wrappers from GMP
	# expect.
	mv config.guess configfsf.guess || die
	mv config.sub configfsf.sub || die
}

multilib_src_configure() {
	# Generally a very fragile package
	strip-flags
	# Miscompiled with LTO at least on arm64, bug #889948
	# 6.3.0 says it now supports LTO, but needs retesting on a variety
	# of platforms. Fix was maybe https://gmplib.org/repo/gmp-6.3/rev/9c324044f4b5.
	filter-lto

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

	# https://gmplib.org/manual/Notes-for-Package-Builds
	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"

		--localstatedir="${EPREFIX}"/var/state/gmp
		--enable-shared

		$(use_enable asm assembly)
		# fat is needed to avoid gmp installing either purely generic
		# or specific-to-used-CPU (which our config.guess refresh prevents at the moment).
		# Both Fedora and opensuse use this option to tackle the issue, bug #883201.
		#
		# This only works for amd64/x86, so to get accelerated performance
		# (i.e. not using the generic C), one needs USE=-cpudetection if
		# on non-amd64/x86.
		#
		# (We do not mask USE=cpudetection on !amd64/x86 because we want
		# the flag to be useful on other arches to allow opting out of the
		# config.guess logic below.)
		$(use_enable cpudetection fat)
		$(use_enable cxx)
		$(use_enable static-libs static)

		# --with-pic forces static libraries to be built as PIC
		# and without TEXTRELs. musl does not support TEXTRELs: bug #707332
		$(use pic && echo --with-pic)

		# XXX: In the past, we had PGO support with upstream's 'tuneup' script
		# per https://gmplib.org/manual/Performance-optimization, but we had
		# a variety of issues with it: bug #454912, bug #650558, and bug #658688.
	)

	# Move the wrappers from GMP back into place (may have been destroyed by previous econf run)
	cp "${T}"/gmp-gnuconfig/config.guess "${S}"/config.guess || die
	cp "${T}"/gmp-gnuconfig/config.sub "${S}"/config.sub || die

	# See bug #883201 again.
	if ! use cpudetection && ! tc-is-cross-compiler ; then
		local gmp_host=$("${S}"/config.guess || die "failed to run config.guess")

		if [[ -z ${gmp_host} ]] ; then
			die "Empty result from GMP's custom config.guess!"
		fi

		einfo "GMP guessed processor type: ${gmp_host}"
		ewarn "This build will only work on this machine. Enable USE=cpudetection for binary packages!"
		export ac_cv_build="${gmp_host}"
		export ac_cv_host="${gmp_host}"
	fi

	# Clang with -fsanitize=address may emit weird section names in its asm,
	# which causes gmp's configure checks to select a broken way of
	# specifying `.rodata`. Disable this feature, which was introduced in
	# Clang 15 (and defaulted to on in Clang 18).
	if tc-is-clang && [[ "$(clang-major-version)" -ge 15 ]]; then
		append-cxxflags "-fno-sanitize-address-globals-dead-stripping"
	fi

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
