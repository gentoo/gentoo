# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
IUSE="gtk xml test"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
	xml? ( virtual/pkgconfig )"

src_prepare() {
	# http://cgit.gentoo.org/proj/sparse.git
	epatch "${FILESDIR}"/${P}-gentoo.patch
}

mymake() {
	usex() { use $1 && echo ${2:-yes} || echo ${3:-no} ; }

	emake \
		V=1 \
		CC="$(tc-getCC)" \
		GCC_BASE="$(gcc-config -L | cut -d : -f1)" \
		HAVE_LIBXML=$(usex xml) \
		HAVE_GTK2=$(usex gtk) \
		PREFIX=/usr \
		LIBDIR="/usr/$(get_libdir)" \
		DESTDIR="${D}" \
		"$@" \
		|| die
}

src_compile() {
	append-flags -fno-strict-aliasing

	mymake \
		$(use test && echo all) all-installable
}

src_install() {
	mymake install
	dodoc FAQ README
}
