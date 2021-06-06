# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib-minimal preserve-libs toolchain-funcs

DESCRIPTION="A library for manipulating integer points bounded by linear constraints"
HOMEPAGE="http://isl.gforge.inria.fr/"
SRC_URI="http://isl.gforge.inria.fr/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/23"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND=">=dev-libs/gmp-5.1.3-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig"

DOCS=( ChangeLog AUTHORS doc/manual.pdf )

PATCHES=(
	"${FILESDIR}"/${PN}-0.19-gdb-autoload-dir.patch
	"${FILESDIR}"/${PN}-0.24-nobash.patch
)

multilib_src_configure() {
	local econf_opts=(
		$(use_enable static-libs static)

		# AX_PROG_CC_FOR_BUILD deficiency:
		# https://wiki.gentoo.org/wiki/Project:Toolchain/use_native_symlinks
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
	)
	if ! tc-is-cross-compiler; then
		# Incorrect CFLAGS handling as CFLAGS_FOR_BUILD
		# even for native builds. As a result -O3 is being used
		# regardless of user's CFLAGS.
		econf_opts+=(
			CFLAGS_FOR_BUILD="${CFLAGS}"
		)
	fi

	ECONF_SOURCE="${S}" econf "${econf_opts[@]}"
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
		/usr/$(get_libdir)/libisl$(get_libname 21) \
		/usr/$(get_libdir)/libisl$(get_libname 22)
}

pkg_postinst() {
	preserve_old_lib_notify \
		/usr/$(get_libdir)/libisl$(get_libname 14) \
		/usr/$(get_libdir)/libisl$(get_libname 15) \
		/usr/$(get_libdir)/libisl$(get_libname 19) \
		/usr/$(get_libdir)/libisl$(get_libname 21) \
		/usr/$(get_libdir)/libisl$(get_libname 22)
}
