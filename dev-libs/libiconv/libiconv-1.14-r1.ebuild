# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit libtool toolchain-funcs multilib-minimal

DESCRIPTION="GNU charset conversion library for libc which doesn't implement it"
HOMEPAGE="https://www.gnu.org/software/libiconv/"
SRC_URI="mirror://gnu/libiconv/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="+static-libs"

DEPEND="!sys-libs/glibc
	!userland_GNU? ( !sys-apps/man-pages )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-no-gets.patch
	elibtoolize
}

multilib_src_configure() {
	# Disable NLS support because that creates a circular dependency
	# between libiconv and gettext
	ECONF_SOURCE="${S}" \
	econf \
		--docdir="\$(datarootdir)/doc/${PF}/html" \
		--disable-nls \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	# Install in /lib as utils installed in /lib like gnutar
	# can depend on this
	gen_usr_ldscript -a iconv charset

	# If we have a GNU userland, we probably have sys-apps/man-pages
	# installed, which means we want to rename our copies #503162.
	# The use of USELAND=GNU is kind of a hack though ...
	if use userland_GNU ; then
		cd "${ED}"/usr/share/man || die
		local f
		for f in man*/*.[0-9] ; do
			mv "${f}" "${f%/*}/${PN}-${f#*/}" || die
		done
	fi
}
