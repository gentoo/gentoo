# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils autotools vcs-snapshot

DESCRIPTION="Exuberant Ctags creates tags files for code browsing in editors"
HOMEPAGE="http://ctags.sourceforge.net"
# this commit is from the sourceforge branch, which is a git-svn clone of the
# original exhuberant-ctags SVN repository
SRC_URI="https://github.com/universal-ctags/ctags/archive/9fce9dd0afd3dd261c681825a61d3e9ffcaa7eea.tar.gz -> ${P}.tar.gz
	ada? ( mirror://sourceforge/gnuada/ctags-ada-mode-4.3.11.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="ada"

RDEPEND="app-eselect/eselect-ctags"

src_prepare() {
	epatch "${FILESDIR}/${PN}-5.6-ebuilds.patch"

	# Bug #273697
	epatch "${FILESDIR}/${PN}-5.8-f95-pointers.patch"

	# enabling Ada support
	if use ada ; then
		cp "${WORKDIR}/${PN}-ada-mode-4.3.11/ada.c" "${S}" || die
		epatch "${FILESDIR}/${PN}-5.8-ada.patch"
	fi

	eautoreconf
}

src_configure() {
	econf \
		--with-posix-regex \
		--without-readlib \
		--disable-etags \
		--enable-tmpdir=/tmp
}

src_install() {
	emake prefix="${D}"/usr mandir="${D}"/usr/share/man install

	# namepace collision with X/Emacs-provided /usr/bin/ctags -- we
	# rename ctags to exuberant-ctags (Mandrake does this also).
	mv "${D}"/usr/bin/{ctags,exuberant-ctags} || die
	mv "${D}"/usr/share/man/man1/{ctags,exuberant-ctags}.1 || die

	dodoc FAQ NEWS README EXTENDING.html
}

pkg_postinst() {
	eselect ctags update
	elog "You can set the version to be started by /usr/bin/ctags through"
	elog "the ctags eselect module. \"man ctags.eselect\" for details."
}

pkg_postrm() {
	eselect ctags update
}
