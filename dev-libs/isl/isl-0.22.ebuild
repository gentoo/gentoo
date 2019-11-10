# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils multilib-minimal preserve-libs

DESCRIPTION="A library for manipulating integer points bounded by linear constraints"
HOMEPAGE="http://isl.gforge.inria.fr/"
SRC_URI="http://isl.gforge.inria.fr/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/22"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-5.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS doc/manual.pdf )

PATCHES=(
	"${FILESDIR}"/${PN}-0.19-gdb-autoload-dir.patch
)

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete
}

pkg_preinst() {
	preserve_old_lib \
		/usr/$(get_libdir)/libisl$(get_libname 14) \
		/usr/$(get_libdir)/libisl$(get_libname 15) \
		/usr/$(get_libdir)/libisl$(get_libname 19) \
		/usr/$(get_libdir)/libisl$(get_libname 21)
}

pkg_postinst() {
	preserve_old_lib_notify \
		/usr/$(get_libdir)/libisl$(get_libname 14) \
		/usr/$(get_libdir)/libisl$(get_libname 15) \
		/usr/$(get_libdir)/libisl$(get_libname 19) \
		/usr/$(get_libdir)/libisl$(get_libname 21)
}
