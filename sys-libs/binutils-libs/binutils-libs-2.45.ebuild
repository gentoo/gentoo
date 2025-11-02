# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a flag-o-matic libtool toolchain-funcs multilib-minimal

DESCRIPTION="Core binutils libraries (libbfd, libopcodes, libiberty) for external packages"
HOMEPAGE="https://sourceware.org/binutils/"

LICENSE="|| ( GPL-3 LGPL-3 )"
IUSE="64-bit-bfd cet multitarget nls static-libs test"

# Variables that can be set here  (ignored for live ebuilds)
# PATCH_VER          - the patchset version
#                      Default: empty, no patching
# PATCH_BINUTILS_VER - the binutils version in the patchset name
#                    - Default: PV
# PATCH_DEV          - Use download URI https://dev.gentoo.org/~{PATCH_DEV}/distfiles/...
#                      for the patchsets

PATCH_VER=1
PATCH_DEV=dilfridge

MY_PN=binutils
MY_P=${MY_PN}-${PV}

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	SLOT="0/${PV}"
elif [[ ${PV} == *9999 ]]; then
	inherit git-r3
	SLOT="0/$(ver_cut 1-2)"
else
	PATCH_BINUTILS_VER=${PATCH_BINUTILS_VER:-${PV}}
	PATCH_DEV=${PATCH_DEV:-dilfridge}
	SRC_URI="mirror://gnu/binutils/${MY_P}.tar.xz
	https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${MY_P}.tar.xz
	https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${MY_PN}-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz"
	SLOT="0/${PV}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

BDEPEND="
	nls? ( sys-devel/gettext )
	test? ( dev-util/dejagnu )
"
DEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
# Need a newer binutils-config that'll reset include/lib symlinks for us.
RDEPEND="${DEPEND}
	>=sys-devel/binutils-config-5
"

RESTRICT="!test? ( test )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bfd.h
)

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		EGIT_REPO_URI="
			https://anongit.gentoo.org/git/proj/toolchain/binutils-patches.git
			https://github.com/gentoo/binutils-patches
		"
		EGIT_CHECKOUT_DIR=${WORKDIR}/patches-git
		git-r3_src_unpack
		mv patches-git/9999 patch || die

		if [[ ${PV} != 9999 ]] ; then
			EGIT_BRANCH=binutils-$(ver_cut 1)_$(ver_cut 2)-branch
		fi
		EGIT_REPO_URI="
			https://sourceware.org/git/binutils-gdb.git
			https://git.sr.ht/~sourceware/binutils-gdb
			https://gitlab.com/x86-binutils/binutils-gdb.git
		"
		S=${WORKDIR}/binutils
		EGIT_CHECKOUT_DIR=${S}
		git-r3_src_unpack
	else
		unpack ${MY_P}.tar.xz

		cd "${WORKDIR}" || die
		unpack binutils-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz

		# _p patch versions are Gentoo specific tarballs ...
		local dir=${MY_P}
		dir=${dir/-hppa64/}

		S=${WORKDIR}/${dir}
	fi

	cd "${WORKDIR}" || die
}

src_prepare() {
	if [[ -n ${PATCH_VER} ]] ; then
		einfo "Applying binutils-${PATCH_BINUTILS_VER} patchset ${PATCH_VER}"
		eapply "${WORKDIR}/patch"/*.patch
	fi

	# Fix cross-compile relinking issue, bug #626402
	elibtoolize

	if [[ ${CHOST} == *-darwin* ]] ; then
		# somehow libtool/configure is messed up and (custom patch at
		# upstream?) and misdetects (basically assumes) nm can be called
		# with -B arg -- can't run eautoreconf (fails), so patch up
		# manually, this would break any target that needs -B to nm
		sed -i -e 's/lt_cv_path_NM="$tmp_nm -B"/lt_cv_path_NM="$tmp_nm"/' \
			libctf/configure || die
	fi

	# See https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html
	# Avoid really confusing logs from subconfigure spam, makes logs far
	# more legible.
	export MAKEOPTS="--output-sync=line ${MAKEOPTS}"

	default
}

pkgversion() {
	printf "Gentoo ${PVR}"
	[[ -n ${PATCHVER} ]] && printf " p${PATCHVER}"
}

src_configure() {
	lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myconf=(
		# portage's econf() does not detect presence of --d-d-t
		# because it greps only top-level ./configure. But not
		# libiberty's or bfd's configure.
		--disable-dependency-tracking
		--disable-silent-rules
		--enable-obsolete
		--enable-shared
		--enable-threads
		# Newer versions (>=2.24) make this an explicit option. #497268
		--enable-install-libiberty
		--disable-werror
		--with-bugurl="https://bugs.gentoo.org/"
		--with-pkgversion="$(pkgversion)"
		$(use_enable static-libs static)
		# The binutils eclass enables this flag for all bi-arch builds,
		# but other tools often don't care about that support.  Put it
		# beyond a flag if people really want it, but otherwise leave
		# it disabled as it can slow things down on 32bit arches. #438522
		$(use_enable 64-bit-bfd)
		# This only disables building in the zlib subdir.
		# For binutils itself, it'll use the system version. #591516
		--without-zlib
		--with-system-zlib
		# We only care about the libs, so disable programs. #528088
		--disable-{binutils,etc,ld,gas,gprof,gprofng}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,gdbserver,libbacktrace,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
		# We pull in all USE-flags that change ABI in an incompatible
		# way. #666100
		# USE=multitarget change size of global arrays
		# USE=64-bit-bfd changes data structures of exported API
		--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}-$(usex multitarget mt st)-$(usex 64-bit-bfd 64 def)

		# Avoid automagic dependency on (currently prefix) systems
		# with debuginfod library, bug #754753
		--without-debuginfod

		# Revisit if it's useful, we do have binutils[zstd] though
		--without-zstd

		# Allow user to opt into CET for host libraries.
		# Ideally we would like automagic-or-disabled here.
		# But the check does not quite work on i686: bug #760926.
		$(use_enable cet)
	)

	# mips can't do hash-style=gnu ...
	if [[ $(tc-arch) != mips ]] ; then
		myconf+=( --enable-default-hash-style=gnu )
	fi

	use multitarget && myconf+=( --enable-targets=all --enable-64-bit-bfd )

	use nls \
		&& myconf+=( --without-included-gettext ) \
		|| myconf+=( --disable-nls )

	if [[ ${CHOST} == *-darwin* ]] && use nls ; then
		# fix underlinking in opcodes
		sed -i -e 's/@SHARED_LDFLAGS@/@SHARED_LDFLAGS@ -lintl/' \
			"${S}"/opcodes/Makefile.in || die
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"

	# Prevent makeinfo from running as we don't build docs here.
	# bug #622652
	sed -i \
		-e '/^MAKEINFO/s:=.*:= true:' \
		Makefile || die
}

multilib_src_test() {
	(
		# Tests don't expect LTO
		filter-lto

		# If we have e.g. -mfpmath=sse -march=pentium4 in CFLAGS,
		# we'll get lto1 warnings for some tests which cause
		# spurious failures because -mfpmath isn't passed at
		# link-time. Filter accordingly.
		#
		# Alternatively, we could pass C{C,XX}_FOR_TARGET with
		# some (ideally not all, surely would break some tests)
		# stuffed in.
		filter-flags '-mfpmath=*'

		# lto-wrapper warnings which confuse tests
		filter-flags '-Wa,*'

		# bug #637066
		filter-flags -Wall -Wreturn-type

		# Note that we need 'check' explicitly if ever cleaning this
		# up: the default `src_test` check for the 'check' target
		# with `-n` may fail with parallel make and silently skip tests (bug #955595)
		emake -k check \
			CFLAGS_FOR_TARGET="${CFLAGS_FOR_TARGET:-${CFLAGS}}" \
			CXXFLAGS_FOR_TARGET="${CXXFLAGS_FOR_TARGET:-${CXXFLAGS}}" \
			LDFLAGS_FOR_TARGET="${LDFLAGS_FOR_TARGET:-${LDFLAGS}}" \
			CFLAGS="${CFLAGS}" \
			CXXFLAGS="${CXXFLAGS}" \
			LDFLAGS="${LDFLAGS}"
	)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	# Provided by dev-debug/gdb instead
	if [[ ${PV} != 9999 ]] ; then
		rm "${ED}"/usr/share/info/sframe-spec.info || die
	fi

	# Provide libiberty.h directly.
	dosym libiberty/libiberty.h /usr/include/libiberty.h
}

multilib_src_install_all() {
	use static-libs || find "${ED}"/usr -name '*.la' -delete
	# Explicit "${ED}" as we need it to do things even w/ USE=-static-libs
	strip-lto-bytecode "${ED}"
}
