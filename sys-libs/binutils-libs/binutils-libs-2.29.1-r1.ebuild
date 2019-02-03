# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PATCHVER="2"
PATCH_BINUTILS_VER="2.29.1"

inherit eutils toolchain-funcs multilib-minimal

MY_PN="binutils"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Core binutils libraries (libbfd, libopcodes, libiberty) for external packages"
HOMEPAGE="https://sourceware.org/binutils/"
SRC_URI="mirror://gnu/binutils/${MY_P}.tar.bz2
	mirror://gentoo/${MY_PN}-${PATCH_BINUTILS_VER}-patches-${PATCHVER}.tar.xz"

LICENSE="|| ( GPL-3 LGPL-3 )"
# The shared lib SONAMEs use the ${PV} in them.
SLOT="0/${PV}"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="64-bit-bfd multitarget nls static-libs"

COMMON_DEPEND="sys-libs/zlib[${MULTILIB_USEDEP}]"
DEPEND="${COMMON_DEPEND}
	>=sys-apps/texinfo-4.7
	nls? ( sys-devel/gettext )"
# Need a newer binutils-config that'll reset include/lib symlinks for us.
RDEPEND="${COMMON_DEPEND}
	>=sys-devel/binutils-config-5
	nls? ( !<sys-devel/gdb-7.10-r1[nls] )"

S="${WORKDIR}/${MY_P}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/bfd.h
)

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
}

pkgversion() {
	printf "Gentoo ${PVR}"
	[[ -n ${PATCHVER} ]] && printf " p${PATCHVER}"
}

multilib_src_configure() {
	local myconf=(
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
		--disable-{binutils,etc,ld,gas,gold,gprof}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
	)

	use multitarget && myconf+=( --enable-targets=all --enable-64-bit-bfd )

	use nls \
		&& myconf+=( --without-included-gettext ) \
		|| myconf+=( --disable-nls )

	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_install() {
	default
	# Provide libiberty.h directly.
	dosym libiberty/libiberty.h /usr/include/libiberty.h
}

multilib_src_install_all() {
	use static-libs || find "${ED}"/usr -name '*.la' -delete
}
