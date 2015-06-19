# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/sparse/sparse-0.4.2.ebuild,v 1.10 2010/12/09 16:33:23 vapier Exp $

EAPI="2"

inherit eutils multilib flag-o-matic toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/devel/sparse/sparse.git"
	inherit git
fi

DESCRIPTION="C semantic parser"
HOMEPAGE="http://sparse.wiki.kernel.org/index.php/Main_Page"

if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="mirror://kernel/software/devel/sparse/dist/${P}.tar.bz2"
	KEYWORDS="amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
fi

LICENSE="OSL-1.1"
SLOT="0"
IUSE=""

src_prepare() {
	sed -i \
		-e '/^PREFIX=/s:=.*:=/usr:' \
		-e "/^LIBDIR=/s:/lib:/$(get_libdir):" \
		Makefile || die
	append-flags -fno-strict-aliasing
	export MAKEOPTS+=" V=1 CC=$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc FAQ README
}
