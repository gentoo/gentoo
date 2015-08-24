# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit flag-o-matic libtool multilib multilib-minimal

EX_P="${PN}-1.8.3"
DESCRIPTION="Standard GNU database libraries"
HOMEPAGE="https://www.gnu.org/software/gdbm/"
SRC_URI="mirror://gnu/gdbm/${P}.tar.gz
	exporter? ( mirror://gnu/gdbm/${EX_P}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+berkdb exporter nls static-libs"

RDEPEND="
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r4
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"

EX_S="${WORKDIR}"/${EX_P}

src_prepare() {
	elibtoolize
}

multilib_src_configure() {
	# gdbm doesn't appear to use either of these libraries
	export ac_cv_lib_dbm_main=no ac_cv_lib_ndbm_main=no

	if multilib_is_native_abi && use exporter ; then
		pushd "${EX_S}" >/dev/null
		append-lfs-flags
		econf --disable-shared
		popd >/dev/null
	fi

	ECONF_SOURCE=${S} \
	econf \
		--includedir="${EPREFIX}"/usr/include/gdbm \
		--with-gdbm183-libdir="${EX_S}/.libs" \
		--with-gdbm183-includedir="${EX_S}" \
		$(use_enable berkdb libgdbm-compat) \
		$(multilib_is_native_abi && use_enable exporter gdbm-export) \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

multilib_src_compile() {
	use exporter && emake -C "${EX_S}" libgdbm.la
	emake
}

multilib_src_install_all() {
	einstalldocs

	use static-libs || find "${ED}" -name '*.la' -delete
	mv "${ED}"/usr/include/gdbm/gdbm.h "${ED}"/usr/include/ || die
}

pkg_preinst() {
	preserve_old_lib libgdbm{,_compat}.so.{2,3} #32510
}

pkg_postinst() {
	preserve_old_lib_notify libgdbm{,_compat}.so.{2,3} #32510
}
