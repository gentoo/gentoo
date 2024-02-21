# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PATCH_VER=5
PATCH_DEV=dilfridge

inherit libtool toolchain-funcs multilib-minimal

MY_PN="binutils"
MY_P="${MY_PN}-${PV}"
PATCH_BINUTILS_VER=${PATCH_BINUTILS_VER:-${PV}}
PATCH_DEV=${PATCH_DEV:-dilfridge}

DESCRIPTION="Core binutils libraries (libbfd, libopcodes, libiberty) for external packages"
HOMEPAGE="https://sourceware.org/binutils/"
SRC_URI="mirror://gnu/binutils/${MY_P}.tar.xz
	https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${MY_P}.tar.xz
	https://dev.gentoo.org/~${PATCH_DEV}/distfiles/${MY_PN}-${PATCH_BINUTILS_VER}-patches-${PATCH_VER}.tar.xz"

LICENSE="|| ( GPL-3 LGPL-3 )"

SLOT="0/${PV%_p?}.0"

IUSE="64-bit-bfd cet multitarget nls static-libs test"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
RESTRICT="!test? ( test )"

BDEPEND="
	nls? ( sys-devel/gettext )
	test? ( dev-util/dejagnu )
"
DEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
# Need a newer binutils-config that'll reset include/lib symlinks for us.
RDEPEND="${DEPEND}
	>=sys-devel/binutils-config-5
"

S="${WORKDIR}/${MY_P%_p?}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bfd.h
)

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
		--disable-{binutils,etc,ld,gas,gold,gprof,gprofng}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
		# We pull in all USE-flags that change ABI in an incompatible
		# way. #666100
		# USE=multitarget change size of global arrays
		# USE=64-bit-bfd changes data structures of exported API
		--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}-$(usex multitarget mt st)-$(usex 64-bit-bfd 64 def)

		# avoid automagic dependency on (currently prefix) systems
		# systems with debuginfod library, bug #754753
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

multilib_src_install() {
	emake DESTDIR="${D}" install

	# Provided by dev-debug/gdb instead
	rm "${ED}"/usr/share/info/sframe-spec.info || die

	# Provide libiberty.h directly.
	dosym libiberty/libiberty.h /usr/include/libiberty.h
}

multilib_src_install_all() {
	use static-libs || find "${ED}"/usr -name '*.la' -delete
}
