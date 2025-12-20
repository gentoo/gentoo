# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is only for the libpng15.so.15 SONAME for ABI compat

inherit libtool multilib-minimal

MY_P="libpng-${PV}"
DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="https://www.libpng.org/"
SRC_URI="https://downloads.sourceforge.net/libpng/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="libpng"
SLOT="1.5"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/zlib:=[${MULTILIB_USEDEP}]
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
	ECONF_SOURCE="${S}" econf
}

multilib_src_compile() {
	emake libpng15.la
}

multilib_src_install() {
	newlib.so .libs/libpng15.so.15.* libpng15.so.15
}
