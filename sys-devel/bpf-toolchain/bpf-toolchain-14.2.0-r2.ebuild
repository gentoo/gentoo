# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs

# Versioning is just the GCC version in full (so may include a snapshot
# date). Unlike dev-util/mingw64-toolchain, which this ebuild was heavily
# inspired by, there's no "third component" here to version on, just
# GCC + binutils.
#
# Do _p1++ rather than revbump on Binutils changes
# Not using Gentoo patchsets for simplicity, their changes are mostly unneeded here.
GCC_PV=${PV/_p/-}
BINUTILS_PV=2.43

DESCRIPTION="All-in-one bpf toolchain for building DTrace and systemd without crossdev"
HOMEPAGE="
	https://gcc.gnu.org/
	https://sourceware.org/binutils/
	https://gcc.gnu.org/wiki/BPFBackEnd
"
SRC_URI="
	mirror://gnu/binutils/binutils-${BINUTILS_PV}.tar.xz
"
if [[ ${GCC_PV} == *-* ]]; then
	SRC_URI+=" mirror://gcc/snapshots/${GCC_PV}/gcc-${GCC_PV}.tar.xz"
else
	SRC_URI+="
		mirror://gcc/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.xz
		mirror://gnu/gcc/gcc-${GCC_PV}/gcc-${GCC_PV}.tar.xz
	"
fi
S="${WORKDIR}"

# l1:binutils+gcc, l2:gcc(libraries)
LICENSE="
	GPL-3+
	LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 )
"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+bin-symlinks custom-cflags +strip"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/mpc:=
	dev-libs/mpfr:=
	sys-libs/zlib:=
	virtual/libiconv
	bin-symlinks? (
		!cross-bpf-unknown-none/binutils
		!cross-bpf-unknown-none/gcc
	)
"
DEPEND="${RDEPEND}"

PATCHES=()

pkg_pretend() {
	[[ ${MERGE_TYPE} == binary ]] && return

	tc-is-cross-compiler &&
		die "cross-compilation of the toolchain itself is unsupported"
}

src_prepare() {
	# rename directories to simplify both patching and the ebuild
	mv binutils{-${BINUTILS_PV},} || die
	mv gcc{-${GCC_PV},} || die

	default
}

src_compile() {
	# src_compile is kept similar to dev-util/mingw64-toolchain
	# at least for now for ease of comparison etc.
	#
	# not great but do everything in src_compile given bootstrapping
	# process needs to be done in steps of configure+compile+install
	# (done modular to have most package-specific things in one place)

	CTARGET=bpf-unknown-none

	BPFT_D=${T}/root # moved to ${D} in src_install
	local bpftdir=/usr/lib/${PN}
	local prefix=${EPREFIX}${bpftdir}
	local sysroot=${BPFT_D}${prefix}
	local -x PATH=${sysroot}/bin:${PATH}

	use custom-cflags || strip-flags # fancy flags are not realistic here

	# global configure flags
	local conf=(
		--build=${CBUILD:-${CHOST}}
		--target=${CTARGET}
		--{doc,info,man}dir=/.skip # let the real binutils+gcc handle docs
		MAKEINFO=: #922230
	)

	# binutils
	local conf_binutils=(
		--prefix="${prefix}"
		--host=${CHOST}
		--disable-cet
		--disable-default-execstack
		--disable-nls
		--disable-shared
		--with-system-zlib
		--without-debuginfod
		--without-msgpack
		--without-zstd
	)

	# gcc (minimal -- if need more, disable only in stage1 / enable in stage3)
	local conf_gcc=(
		--prefix="${prefix}"
		--host=${CHOST}
		--disable-bootstrap
		--disable-cc1
		--disable-cet
		--disable-gcov #843989
		--disable-gomp
		--disable-nls # filename collisions
		--disable-libcc1
		--disable-libquadmath
		--disable-libsanitizer
		--disable-libssp
		--disable-libvtv
		--disable-shared
		--disable-werror
		--enable-languages=c
		--with-gcc-major-version-only
		--with-system-zlib
		--without-isl
		--without-zstd
		--disable-multilib
	)

	# libstdc++ may misdetect sys/sdt.h on systemtap-enabled system and fail
	# (not passed in conf_gcc above given it is lost in sub-configure calls)
	local -x glibcxx_cv_sys_sdt_h=no

	# bpft-build <path/package-name>
	# -> ./configure && make && make install && bpft-package()
	# passes conf and conf_package to configure, and users can add options
	# through environment with e.g.
	#	BPFT_BINUTILS_CONF="--some-option"
	#	EXTRA_ECONF="--global-option" (generic naming for if not reading this)
	bpft-build() {
		local id=${1##*/}
		local build_dir=${WORKDIR}/${1}-build

		# econf is not allowed in src_compile and its defaults are
		# mostly unused here, so use configure directly
		local conf=( "${WORKDIR}/${1}"/configure "${conf[@]}" )

		local -n conf_id=conf_${id}
		[[ ${conf_id@a} == *a* ]] && conf+=( "${conf_id[@]}" )

		local -n extra_id=BPFT_${id^^}_CONF
		conf+=( ${EXTRA_ECONF} ${extra_id} )

		einfo "Building ${id} in ${build_dir} ..."

		mkdir -p "${build_dir}" || die
		pushd "${build_dir}" >/dev/null || die

		edo "${conf[@]}"
		emake MAKEINFO=: V=1
		# -j1 to match bug #906155, other packages may be fragile too
		emake -j1 MAKEINFO=: V=1 DESTDIR="${BPFT_D}" install

		declare -f bpft-${id} >/dev/null && edo bpft-${id}

		popd >/dev/null || die
	}

	# build with same ordering that crossdev would do
	bpft-build binutils
	bpft-build gcc

	if use bin-symlinks; then
		mkdir -p -- "${BPFT_D}${EPREFIX}"/usr/bin/ || die
		local bin
		for bin in "${sysroot}"/bin/*; do
			ln -rs -- "${bin}" "${BPFT_D}${EPREFIX}"/usr/bin/ || die
		done
	fi

	# Delete libdep.a, which has a colliding name and is useless for bpf,
	# which does not make use of cross-library dependencies: the libdep.a
	# for the native binutils will do.
	rm -f ${sysroot}/lib/bfd-plugins/libdep.a || die

	# portage doesn't know the right strip executable to use for CTARGET
	# and it can lead to .a mangling, notably with 32bit (breaks toolchain)
	dostrip -x ${bpftdir}/{${CTARGET}/lib{,32},lib/gcc/${CTARGET}}

	# TODO: Check if this is worth doing, it may not be
	if use strip; then
		einfo "Stripping ${CTARGET} static libraries ..."
		find "${sysroot}"/{,lib/gcc/}${CTARGET} -type f -name '*.a' \
			-exec ${CTARGET}-strip --strip-unneeded {} + || die
	fi
}

src_install() {
	mv "${BPFT_D}${EPREFIX}"/* "${ED}" || die

	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	use bin-symlinks && has_version dev-util/shadowman && [[ ! ${ROOT} ]] &&
		eselect compiler-shadow update all

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Note that this package is primarily intended for DTrace, systemd, and related"
		elog "packages to depend on without needing a manual crossdev setup."
		elog
		elog "Settings are oriented only for what these need and simplicity."
		elog "Use sys-devel/crossdev if need full toolchain/customization:"
		elog "    https://wiki.gentoo.org/wiki/Crossdev"
	fi
}

pkg_postrm() {
	use bin-symlinks && has_version dev-util/shadowman && [[ ! ${ROOT} ]] &&
		eselect compiler-shadow clean all
}
