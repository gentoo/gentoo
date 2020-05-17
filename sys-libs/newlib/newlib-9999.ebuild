# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://sourceware.org/git/newlib-cygwin.git"
	inherit git-r3
else
	SRC_URI="ftp://sourceware.org/pub/newlib/${P}.tar.gz"
	KEYWORDS="-* ~arm ~hppa ~m68k ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION="Newlib is a C library intended for use on embedded systems"
HOMEPAGE="https://sourceware.org/newlib/"

LICENSE="NEWLIB LIBGLOSS GPL-2"
SLOT="0"
IUSE="nls threads unicode headers-only nano"
RESTRICT="strip"

NEWLIBBUILD="${WORKDIR}/build"
NEWLIBNANOBUILD="${WORKDIR}/build.nano"
NEWLIBNANOTMPINSTALL="${WORKDIR}/nano_tmp_install"

# Adding -U_FORTIFY_SOURCE to counter the effect of Gentoo's
# auto-addition of _FORTIFY_SOURCE at gcc site: bug #656018#c4
# Currently newlib can't be built itself when _FORTIFY_SOURCE
# is set.
CFLAGS_FULL="-ffunction-sections -fdata-sections -U_FORTIFY_SOURCE"
CFLAGS_NANO="-Os -ffunction-sections -fdata-sections -U_FORTIFY_SOURCE"

pkg_setup() {
	# Reject newlib-on-glibc type installs
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		case ${CHOST} in
			*-newlib|*-elf) ;;
			*) die "Use sys-devel/crossdev to build a newlib toolchain" ;;
		esac
	fi

	case ${CTARGET} in
		msp430*)
			if ver_test $(gcc-version ${CTARGET}) -lt 10.1; then
				# bug #717610
				die "gcc for ${CTARGET} has to be 10.1 or above"
			fi
			;;
	esac
}

src_configure() {
	# we should fix this ...
	unset LDFLAGS
	CHOST=${CTARGET} strip-unsupported-flags
	CCASFLAGS_ORIG="${CCASFLAGS}"
	CFLAGS_ORIG="${CFLAGS}"

	local myconf=(
		# Disable legacy syscall stub code in newlib.  These have been
		# moved to libgloss for a long time now, so the code in newlib
		# itself just gets in the way.
		--disable-newlib-supplied-syscalls
	)
	[[ ${CTARGET} == "spu" ]] \
		&& myconf+=( --disable-newlib-multithread ) \
		|| myconf+=( $(use_enable threads newlib-multithread) )

	mkdir -p "${NEWLIBBUILD}"
	cd "${NEWLIBBUILD}"

	export "CFLAGS_FOR_TARGET=${CFLAGS_ORIG} ${CFLAGS_FULL}"
	export "CCASFLAGS=${CCASFLAGS_ORIG} ${CFLAGS_FULL}"
	ECONF_SOURCE=${S} \
	econf \
		$(use_enable unicode newlib-mb) \
		$(use_enable nls) \
		"${myconf[@]}"

	# Build newlib-nano beside newlib (original)
	# Based on https://tracker.debian.org/media/packages/n/newlib/rules-2.1.0%2Bgit20140818.1a8323b-2
	if use nano ; then
		mkdir -p "${NEWLIBNANOBUILD}" || die
		cd "${NEWLIBNANOBUILD}" || die
		export "CFLAGS_FOR_TARGET=${CFLAGS_ORIG} ${CFLAGS_NANO}"
		export "CCASFLAGS=${CCASFLAGS_ORIG} ${CFLAGS_NANO}"
		ECONF_SOURCE=${S} \
		econf \
			$(use_enable unicode newlib-mb) \
			$(use_enable nls) \
			--enable-newlib-reent-small \
			--disable-newlib-fvwrite-in-streamio \
			--disable-newlib-fseek-optimization \
			--disable-newlib-wide-orient \
			--enable-newlib-nano-malloc \
			--disable-newlib-unbuf-stream-opt \
			--enable-lite-exit \
			--enable-newlib-global-atexit \
			--enable-newlib-nano-formatted-io \
			${myconf}
	fi
}

src_compile() {
	export "CFLAGS_FOR_TARGET=${CFLAGS_ORIG} ${CFLAGS_FULL}"
	export "CCASFLAGS=${CCASFLAGS_ORIG} ${CFLAGS_FULL}"
	emake -C "${NEWLIBBUILD}"

	if use nano ; then
		export "CFLAGS_FOR_TARGET=${CFLAGS_ORIG} ${CFLAGS_NANO}"
		export "CCASFLAGS=${CCASFLAGS_ORIG} ${CFLAGS_NANO}"
		emake -C "${NEWLIBNANOBUILD}"
	fi
}

src_install() {
	cd "${NEWLIBBUILD}" || die
	emake -j1 DESTDIR="${D}" install

	if use nano ; then
		cd "${NEWLIBNANOBUILD}" || die
		emake -j1 DESTDIR="${NEWLIBNANOTMPINSTALL}" install
		# Rename nano lib* files to lib*_nano and move to the real ${D}
		local nanolibfiles=""
		nanolibfiles=$(find "${NEWLIBNANOTMPINSTALL}" -regex ".*/lib\(c\|g\|rdimon\)\.a" -print)
		for f in ${nanolibfiles}; do
			local l="${f##${NEWLIBNANOTMPINSTALL}}"
			mv -v "${f}" "${D}/${l%%\.a}_nano.a" || die
		done

		# Move newlib-nano's version of newlib.h to newlib-nano/newlib.h
		mkdir -p "${D}/usr/${CTARGET}/include/newlib-nano" || die
		mv "${NEWLIBNANOTMPINSTALL}/usr/${CTARGET}/include/newlib.h" \
			"${D}/usr/${CTARGET}/include/newlib-nano/newlib.h" || die
	fi

	# minor hack to keep things clean
	rm -rf "${D}"/usr/share/info || die
	rm -rf "${D}"/usr/info || die
}
