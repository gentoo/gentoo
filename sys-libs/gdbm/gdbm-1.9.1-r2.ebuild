# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils libtool flag-o-matic

EX_P="${PN}-1.8.3"
DESCRIPTION="Standard GNU database libraries"
HOMEPAGE="http://www.gnu.org/software/gdbm/"
SRC_URI="mirror://gnu/gdbm/${P}.tar.gz
	exporter? ( mirror://gnu/gdbm/${EX_P}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+berkdb exporter static-libs"

EX_S="${WORKDIR}"/${EX_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-compat-link.patch #383743
	elibtoolize
}

src_configure() {
	# gdbm doesn't appear to use either of these libraries
	export ac_cv_lib_dbm_main=no ac_cv_lib_ndbm_main=no

	if use exporter ; then
		pushd "${EX_S}" >/dev/null
		append-lfs-flags
		econf --disable-shared
		popd >/dev/null
	fi

	econf \
		--includedir="${EPREFIX}"/usr/include/gdbm \
		--with-gdbm183-libdir="${EX_S}/.libs" \
		--with-gdbm183-includedir="${EX_S}" \
		$(use_enable berkdb libgdbm-compat) \
		$(use_enable exporter gdbm-export) \
		$(use_enable static-libs static)
}

src_compile() {
	if use exporter ; then
		emake -C "${WORKDIR}"/${EX_P} libgdbm.la || die
	fi

	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static-libs || find "${ED}" -name '*.la' -delete
	mv "${ED}"/usr/include/gdbm/gdbm.h "${ED}"/usr/include/ || die
	dodoc ChangeLog NEWS README
}

pkg_preinst() {
	preserve_old_lib libgdbm{,_compat}.so.{2,3} #32510
}

pkg_postinst() {
	preserve_old_lib_notify libgdbm{,_compat}.so.{2,3} #32510
}
