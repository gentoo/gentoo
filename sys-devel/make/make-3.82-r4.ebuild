# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/make/make-3.82-r4.ebuild,v 1.16 2014/01/18 03:11:00 vapier Exp $

EAPI="2"

inherit flag-o-matic eutils

DESCRIPTION="Standard tool to compile source trees"
HOMEPAGE="http://www.gnu.org/software/make/make.html"
SRC_URI="mirror://gnu//make/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls static"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-archives-many-objs.patch #334889
	epatch "${FILESDIR}"/${P}-MAKEFLAGS-reexec.patch #31975
	epatch "${FILESDIR}"/${P}-memory-corruption.patch #355907
	epatch "${FILESDIR}"/${P}-glob-speedup.patch #382845
	epatch "${FILESDIR}"/${P}-copy-on-expand.patch
	epatch "${FILESDIR}"/${P}-oneshell.patch
	epatch "${FILESDIR}"/${P}-parallel-remake.patch
	epatch "${FILESDIR}"/${P}-intermediate-parallel.patch #431250
	epatch "${FILESDIR}"/${P}-construct-command-line.patch
	epatch "${FILESDIR}"/${P}-long-command-line.patch
	epatch "${FILESDIR}"/${P}-darwin-library_search-dylib.patch
}

src_configure() {
	use static && append-ldflags -static
	econf \
		--program-prefix=g \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README*
	if [[ ${USERLAND} == "GNU" ]] ; then
		# we install everywhere as 'gmake' but on GNU systems,
		# symlink 'make' to 'gmake'
		dosym gmake /usr/bin/make
		dosym gmake.1 /usr/share/man/man1/make.1
	fi
}
