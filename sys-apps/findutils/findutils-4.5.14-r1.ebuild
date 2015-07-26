# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/findutils/findutils-4.5.14-r1.ebuild,v 1.3 2015/07/20 04:32:29 vapier Exp $

EAPI="4"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="GNU utilities for finding files"
HOMEPAGE="http://www.gnu.org/software/findutils/"
SRC_URI="mirror://gnu-alpha/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug nls selinux static"

RDEPEND="selinux? ( sys-libs/libselinux )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-test-bashisms.patch #531020
	# Don't build or install locate because it conflicts with slocate,
	# which is a secure version of locate.  See bug 18729
	sed -i '/^SUBDIRS/s/locate//' Makefile.in

	# Disable gnulib build test that has no impact on the source.
	# Re-enable w/next version bump (and gnulib is updated). #554728
	[[ ${PV} != "4.5.14" ]] && die "re-enable test #554728"
	echo 'exit 0' > tests/test-update-copyright.sh || die
}

src_configure() {
	use static && append-ldflags -static

	program_prefix=$(usex userland_GNU '' g)
	econf \
		--with-packager="Gentoo" \
		--with-packager-version="${PVR}" \
		--with-packager-bug-reports="http://bugs.gentoo.org/" \
		--program-prefix=${program_prefix} \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_with selinux) \
		--libexecdir='$(libdir)'/find
}

src_install() {
	default

	# We don't need this, so punt it.
	rm "${ED}"/usr/bin/${program_prefix}oldfind \
		"${ED}"/usr/share/man/man1/${program_prefix}oldfind.1 || die
}
