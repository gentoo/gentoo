# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="A loop generator for scanning polyhedra"
HOMEPAGE="http://www.bastoul.net/cloog/ https://github.com/periscop/cloog"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/periscop/cloog"
else
	SRC_URI="https://github.com/periscop/cloog/archive/${P}.tar.gz"
	S="${WORKDIR}"/cloog-${P}
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0/4"
IUSE="static-libs"

RDEPEND="
	dev-libs/gmp:=
	dev-libs/isl:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-0.20.0-notex.patch )

DOCS=( README )

src_prepare() {
	default
	AT_NO_RECURSIVE=yes eautoreconf -i
	# m4/ax_create_pkgconfig_info.m4 includes LDFLAGS
	# sed to avoid eautoreconf
	sed -i -e '/Libs:/s:@LDFLAGS@ ::' configure || die

	# Make sure we always use the system isl.
	rm -rf isl || die
}

src_configure() {
	ECONF_SOURCE="${S}" econf \
		--with-gmp=system \
		--with-isl=system \
		--with-osl=no \
		$(use_enable static-libs static)
}

# The default src_test() fails, so we'll just run these directly
src_test() {
	emake -j1 check
}
