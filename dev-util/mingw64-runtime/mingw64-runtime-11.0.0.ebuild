# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit crossdev flag-o-matic toolchain-funcs

DESCRIPTION="Free Win64 runtime and import library definitions"
HOMEPAGE="https://www.mingw-w64.org/"
SRC_URI="mirror://sourceforge/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v${PV}.tar.bz2"
S="${WORKDIR}/mingw-w64-v${PV}"

LICENSE="ZPL BSD BSD-2 ISC LGPL-2+ LGPL-2.1+ MIT public-domain tools? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# default-ucrt: enabling requires to be done during the bootstrap process
# or else will cause e.g. undefined reference to __intrinsic_setjmpex
# libraries: needs working stage2 compiler (bug #665512)
IUSE="default-ucrt headers-only idl libraries tools"
RESTRICT="strip" # portage would use the wrong strip executable

pkg_setup() {
	target_is_not_host && MW_CROSS=true || MW_CROSS=false
	[[ ${CBUILD} == ${CHOST} && ${CTARGET} == ${CHOST} ]] &&
		die "Invalid configuration, please see: https://wiki.gentoo.org/wiki/Mingw"
}

mingw-foreach_tool() {
	use !tools || use headers-only && return

	local tool=widl
	if use !amd64 && use !x86 && use !arm64 && use !arm; then
		einfo "Skipping widl due to unsupported platform" #853250
		tool=
	fi

	for tool in gendef genidl ${tool}; do
		# not using top-level --with-tools given it skips widl
		pushd mingw-w64-tools/${tool} >/dev/null || die
		"${@}"
		popd >/dev/null || die
	done
}

src_configure() {
	# native tools, see #644556
	local toolsconf=()
	# normally only widl is prefixed, but avoids clash with other targets
	${MW_CROSS} && toolsconf+=( --program-prefix=${CTARGET}- )

	mingw-foreach_tool econf "${toolsconf[@]}"

	MW_LDFLAGS=${LDFLAGS} # keep non-stripped for gendef not respecting it

	# likely cross-compiling from here, update toolchain variables
	if ${MW_CROSS} && [[ ! -v MINGW_BYPASS ]]; then
		unset AR AS CC CPP CXX DLLTOOL LD NM OBJCOPY OBJDUMP RANLIB RC STRIP
		filter-flags '-fuse-ld=*'
		filter-flags '-mfunction-return=thunk*' #878849
	fi
	local CHOST=${CTARGET}

	# some bashrc-mv users tend to do CFLAGS="${LDFLAGS}" and then
	# strip-unsupported-flags miss these during compile-only tests
	# (primarily done for 23.0 profiles' -z, not full coverage)
	filter-flags '-Wl,-z,*'

	# -mavx with mingw-gcc has a history of obscure issues and
	# disabling is seen as safer, e.g. `WINEARCH=win32 winecfg`
	# crashes with -march=skylake >=wine-8.10, similar issues with
	# znver4: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110273
	tc-is-gcc && append-flags -mno-avx

	strip-unsupported-flags

	# Normally mingw64 does not use dynamic linker, but at configure time it
	# uses LDFLAGS. When -Wl,--hash-style=gnu is passed __CTORS_LIST__ /
	# __DTORS_LIST__ is misdetected for target and binaries crash at shutdown.
	# Note: typically also stripped by strip-unsupported-flags, but not during
	# USE=headers-only and potentially other configurations (kept as safety).
	filter-ldflags '-Wl,--hash-style=*'

	local prefix=${EPREFIX}/usr
	${MW_CROSS} && prefix+=/${CTARGET}/usr

	local conf=(
		--prefix="${prefix}"
		--libdir="${prefix}"/lib
		$(use_with !headers-only crt)
		$(usev default-ucrt --with-default-msvcrt=ucrt)

		# By default configure tries to set --sysroot=${prefix}. We disable
		# this behaviour with --with-sysroot=no to use gcc's sysroot default.
		# That way we can cross-build mingw64-runtime with cross-emerge.
		--with-sysroot=no
	)

	if use !headers-only; then
		conf+=(
			$(use_enable idl)
			$(use_with libraries)
		)

		# prefer tuple to determine if should do 32 or 64bits, but fall
		# back to cpp test if missing (bug #584858, see also #840662)
		local b32=true
		case ${CHOST} in
			x86_64-*) b32=false;;
			i*86-*) ;;
			*) [[ $($(tc-getCPP) -dM - <<<'') =~ __MINGW64__ ]] && b32=false;;
		esac
		${b32} &&
			conf+=( --enable-lib32 --disable-lib64 ) ||
			conf+=( --disable-lib32 --enable-lib64 )

		# prepare temporary headers install to build against same-version
		mkdir ../headers || die
		pushd ../headers >/dev/null || die
		ECONF_SOURCE=${S} econf --prefix="${T}"/root --without-crt
		popd >/dev/null || die

		append-cppflags "-I${T}/root/include"
	fi

	econf "${conf[@]}"
}

src_compile() {
	use headers-only || emake -C ../headers install
	emake
	mingw-foreach_tool emake LDFLAGS="${MW_LDFLAGS}"
}

src_install() {
	default

	mingw-foreach_tool emake DESTDIR="${D}" install

	if ${MW_CROSS}; then
		# gcc is configured to look at specific hard-coded paths for mingw #419601
		dosym usr /usr/${CTARGET}/mingw
		dosym usr /usr/${CTARGET}/${CTARGET}
		dosym usr/include /usr/${CTARGET}/sys-include
	fi

	rm -r "${ED}"/usr/share || die
}
