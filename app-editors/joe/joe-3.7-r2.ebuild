# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit flag-o-matic eutils

DESCRIPTION="A free ASCII-Text Screen Editor for UNIX"
HOMEPAGE="http://sourceforge.net/projects/joe-editor/"
SRC_URI="mirror://sourceforge/joe-editor/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ~ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris"
IUSE="xterm"

DEPEND=">=sys-libs/ncurses-5.2-r2"
RDEPEND="xterm? ( >=x11-terms/xterm-239 )"

src_prepare() {
	# Fix segfault, bug 283508
	epatch "${FILESDIR}/${P}-segfault-fix.patch"
	epatch "${FILESDIR}/${P}-sanitise-includes.patch"
	epatch "${FILESDIR}/${P}-ftyperc.patch"

	cd "${S}"/rc

	# Enable xterm mouse support in the rc files
	if use xterm; then
		for i in *rc*.in; do
			sed -e 's/^ -\(mouse\|joexterm\)/-\1/' -i "${i}" || die "sed failed"
		done
	fi
}

src_configure() {
	# Bug 34609 (joe 2.9.8 editor seg-faults on 'find and replace' when compiled with -Os)
	replace-flags "-Os" "-O2"

	econf --docdir="${EPREFIX}"/usr/share/doc/${PF} || die
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc ChangeLog HACKING HINTS LIST NEWS README TODO
}

pkg_postinst() {
	if use xterm; then
		elog "To enable full xterm clipboard you need to set the allowWindowOps"
		elog "resources to true. This is usually found in /etc/X11/app-defaults/XTerm"
		elog "This is false by default due to potential security problems on some"
		elog "architectures (see bug #91453)."
	fi
}
