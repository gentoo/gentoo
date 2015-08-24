# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

DESCRIPTION="Manage installation of software in /var/lib/"
HOMEPAGE="https://www.gnu.org/software/stow/"
SRC_URI="mirror://gnu/stow/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

DEPEND="dev-lang/perl
	test? (
		virtual/perl-Test-Harness
		dev-perl/Test-Output
	)"
RDEPEND="dev-lang/perl"

src_prepare() {
	epatch "${FILESDIR}/${P}-avoid-precedence-warning.patch"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."

	# create new STOWDIR
	dodir /var/lib/stow

	# install env.d file to add STOWDIR to PATH and LDPATH
	doenvd "${FILESDIR}"/99stow || die "doenvd failed"
}

pkg_postinst() {
	elog "We now recommend that you use /var/lib/stow as your STOWDIR"
	elog "instead of /usr/local in order to avoid conflicts with the"
	elog "symlink from /usr/lib64 -> /usr/lib.  See Bug 246264 for"
	elog "more details on this change."
	elog "For your convenience, PATH has been updated to include"
	elog "/var/lib/stow/bin."
}
