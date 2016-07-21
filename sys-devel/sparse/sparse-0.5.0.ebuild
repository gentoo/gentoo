# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/devel/sparse/sparse.git"
	inherit git-2
fi

DESCRIPTION="C semantic parser"
HOMEPAGE="https://sparse.wiki.kernel.org/index.php/Main_Page"

if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	#KEYWORDS=""
else
	SRC_URI="mirror://kernel/software/devel/sparse/dist/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="OSL-1.1"
SLOT="0"
IUSE="gtk llvm test xml"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	llvm? ( >=sys-devel/llvm-3.0 )
	xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	gtk? ( virtual/pkgconfig )
	xml? ( virtual/pkgconfig )"

src_prepare() {
	tc-export AR CC PKG_CONFIG
	sed -i \
		-e '/^PREFIX=/s:=.*:=/usr:' \
		-e "/^LIBDIR=/s:/lib:/$(get_libdir):" \
		-e '/^CFLAGS =/{s:=:+= $(CPPFLAGS):;s:-O2 -finline-functions::}' \
		-e "s:pkg-config:${PKG_CONFIG}:" \
		Makefile || die
	export MAKEOPTS+=" V=1 AR=${AR} CC=${CC} HAVE_GTK2=$(usex gtk) HAVE_LLVM=$(usex llvm) HAVE_LIBXML=$(usex xml)"
}

src_compile() {
	emake $(usex test all all-installable)
}
