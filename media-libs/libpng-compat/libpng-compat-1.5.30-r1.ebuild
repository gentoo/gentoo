# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is only for the libpng15.so.15 SONAME for ABI compat

inherit libtool multilib-minimal

MY_P="libpng-${PV}"
DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/libpng/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="libpng"
SLOT="1.5"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="cpu_flags_arm_neon"

RDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	!=media-libs/libpng-1.5*
"
DEPEND="${RDEPEND}"

# Don't install any docs here because we're literally just installing the
# old library for compatibility. Use libpng for the full contents.
DOCS=()

pkg_setup() {
	local _preserved_lib="${EROOT}/usr/$(get_libdir)/libpng15.so.15"
	[[ -e ${_preserved_lib} ]] && rm -f "${_preserved_lib}"
}

src_prepare() {
	default

	elibtoolize
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable cpu_flags_arm_neon arm-neon check)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake libpng15.la
}

multilib_src_install() {
	newlib.so .libs/libpng15.so.15.* libpng15.so.15
}
