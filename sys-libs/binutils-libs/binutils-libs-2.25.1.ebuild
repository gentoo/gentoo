# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PATCHVER="1.1"

inherit eutils

MY_PN="binutils"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Core binutils libraries (libbfd, libopcodes, libiberty) for external packages"
HOMEPAGE="https://sourceware.org/binutils/"
SRC_URI="mirror://gnu/binutils/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-patches-${PATCHVER}.tar.xz"

LICENSE="|| ( GPL-3 LGPL-3 )"
# The shared lib SONAMEs use the ${PV} in them.
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd -sparc-fbsd ~x86-fbsd"
IUSE="nls static-libs zlib"

COMMON_DEPEND="zlib? ( sys-libs/zlib )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"
# Need a newer binutils-config that'll reset include/lib symlinks for us.
RDEPEND="${COMMON_DEPEND}
	>=sys-devel/binutils-config-5
	nls? ( !<sys-devel/gdb-7.10-r1[nls] )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
}

pkgversion() {
	printf "Gentoo ${PVR}"
	[[ -n ${PATCHVER} ]] && printf " p${PATCHVER}"
}

src_configure() {
	local myconf=(
		$(use_with zlib)
		--enable-obsolete
		--enable-shared
		--enable-threads
		# Newer versions (>=2.24) make this an explicit option. #497268
		--enable-install-libiberty
		--disable-werror
		--with-bugurl="https://bugs.gentoo.org/"
		--with-pkgversion="$(pkgversion)"
		$(use_enable static-libs static)
		# We only care about the libs, so disable programs. #528088
		--disable-{binutils,etc,ld,gas,gold,gprof}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
	)

	use nls \
		&& myconf+=( --without-included-gettext ) \
		|| myconf+=( --disable-nls )

	econf "${myconf[@]}"
}

src_install() {
	default
	use static-libs || find "${ED}"/usr -name '*.la' -delete
	# Provide libiberty.h directly.
	dosym libiberty/libiberty.h /usr/include/libiberty.h
}
