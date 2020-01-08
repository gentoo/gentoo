# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# this ebuild is only for the libpng15.so.15 SONAME for ABI compat

inherit eutils libtool multilib-minimal

MY_P=libpng-${PV}
DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/libpng/${MY_P}.tar.xz
	apng? ( https://dev.gentoo.org/~polynomial-c/${MY_P}-apng.patch.gz )"
S=${WORKDIR}/${MY_P}

LICENSE="libpng"
SLOT="1.5"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="apng neon"

RDEPEND="sys-libs/zlib:=[${MULTILIB_USEDEP}]
	!=media-libs/libpng-1.5*"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

DOCS=""

pkg_setup() {
	local _preserved_lib=${EROOT}/usr/$(get_libdir)/libpng15.so.15
	[[ -e ${_preserved_lib} ]] && rm -f "${_preserved_lib}"
}

src_prepare() {
	default
	if use apng; then
		# fix windows path in patch file. Please check for each release if this can be removed again.
		sed 's@scripts\\symbols.def@scripts/symbols.def@' \
			-i "${WORKDIR}"/${PN}-*-apng.patch || die
		eapply "${WORKDIR}"/${PN}-*-apng.patch
		# Don't execute symbols check with apng patch wrt #378111
		sed -i -e '/^check/s:scripts/symbols.chk::' Makefile.in || die
	fi
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--disable-static \
		--enable-arm-neon=$(usex neon)
}

multilib_src_compile() {
	emake libpng15.la
}

multilib_src_install() {
	newlib.so .libs/libpng15.so.15.* libpng15.so.15
}
