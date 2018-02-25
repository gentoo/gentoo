# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs

DESCRIPTION="C semantic parser"
HOMEPAGE="https://sparse.wiki.kernel.org/index.php/Main_Page"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/devel/${PN}/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://kernel/software/devel/${PN}/dist/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="MIT"
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
		-e '/^COMMON_CFLAGS =/{s:=:= $(CPPFLAGS):;s:-O2 -finline-functions -fno-strict-aliasing -g:-fno-strict-aliasing:}' \
		-e "s:pkg-config:${PKG_CONFIG}:" \
		Makefile || die
	export MAKEOPTS+=" V=1 AR=${AR} CC=${CC} HAVE_GTK2=$(usex gtk) HAVE_LLVM=$(usex llvm) HAVE_LIBXML=$(usex xml)"
	default
}

src_compile() {
	emake $(usex test all all-installable)
}
