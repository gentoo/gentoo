# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib flag-o-matic libtool toolchain-funcs

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="https://www.gnu.org/software/libiconv/"
SRC_URI="mirror://gnu/libiconv/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd"
IUSE=""

DEPEND="!sys-libs/glibc
	!sys-apps/man-pages"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# This patch is needed as libiconv 1.10 provides (and uses) new functions
	# and they are not present in the old libiconv.so, and this breaks the
	# ${DESTDIR} != ${prefix} that we use. It's a problem for Solaris, but we
	# don't have to deal with it for now.
	#epatch "${FILESDIR}"/${PN}-1.10-link.patch

	# Make sure that libtool support is updated to link "the linux way" on
	# FreeBSD.
	elibtoolize
}

src_compile() {
	# Install in /lib as utils installed in /lib like gnutar
	# can depend on this

	# Disable NLS support because that creates a circular dependency
	# between libiconv and gettext

	econf \
		--disable-nls \
		--enable-shared \
		--enable-static \
		 || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}/html" install || die "make install failed"

	# Move static libs and creates ldscripts into /usr/lib
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/lib{iconv,charset}*$(get_libname)* "${D}/$(get_libdir)" || die
	gen_usr_ldscript libiconv$(get_libname)
	gen_usr_ldscript libcharset$(get_libname)
}
