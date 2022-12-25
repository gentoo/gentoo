# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild is only for the libpng12.so.0 SONAME for ABI compat

inherit libtool multilib-minimal

MY_P=libpng-${PV}
DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/libpng/${MY_P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="libpng"
SLOT="1.2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	!=media-libs/libpng-1.2*
"
DEPEND="${RDEPEND}"

# Don't install any docs here because we're literally just installing the
# old library for compatibility. Use libpng for the full contents.
DOCS=()

src_prepare() {
	default

	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

multilib_src_compile() {
	emake libpng12.la
}

multilib_src_install() {
	newlib.so .libs/libpng12.so.0.* libpng12.so.0
}
