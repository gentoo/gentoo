# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/findutils/findutils-4.5.12.ebuild,v 1.4 2014/01/18 03:28:44 vapier Exp $

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs multilib

DESCRIPTION="GNU utilities for finding files"
HOMEPAGE="http://www.gnu.org/software/findutils/"
SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls selinux static"

RDEPEND="selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	# Don't build or install locate because it conflicts with slocate,
	# which is a secure version of locate.  See bug 18729
	sed -i '/^SUBDIRS/s/locate//' Makefile.in
}

src_configure() {
	use static && append-ldflags -static

	program_prefix=$(usex userland_GNU '' g)
	econf \
		--with-packager="Gentoo" \
		--with-packager-version="${PVR}" \
		--with-packager-bug-reports="http://bugs.gentoo.org/" \
		--program-prefix=${program_prefix} \
		$(use_enable nls) \
		$(use_with selinux) \
		--libexecdir='$(libdir)'/find
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS README TODO ChangeLog

	# We don't need this, so punt it.
	rm "${ED}"/usr/bin/${program_prefix}oldfind \
		"${ED}"/usr/share/man/man1/${program_prefix}oldfind.1 || die
}
