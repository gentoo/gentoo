# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic usr-ldscript

DESCRIPTION="Password database"
HOMEPAGE="https://packages.gentoo.org/package/sys-libs/pwdb"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="selinux"
RESTRICT="test" #122603

# Note: NIS could probably be made conditional if anyone cared ...
RDEPEND="
	net-libs/libnsl:0=
	net-libs/libtirpc
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGES CREDITS README doc/pwdb.txt )
HTML_DOCS=( doc/html/. )

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-disable-static.patch # bug 725972
)

src_prepare() {
	default

	use selinux && eapply "${FILESDIR}"/${P}-selinux.patch

	append-cppflags $($(tc-getPKG_CONFIG) --cflags libtirpc)
	export LDLIBS=$($(tc-getPKG_CONFIG) --libs libtirpc)

	sed -i \
		-e "s/^DIRS = .*/DIRS = libpwdb/" \
		-e "s;EXTRAS += ;EXTRAS += ${CFLAGS} ;" \
		Makefile || die
	sed -i \
		-e "s:=gcc:=$(tc-getCC):g" \
		-e "s:=ar:=$(tc-getAR):g" \
		-e "s:=ranlib:=$(tc-getRANLIB):g" \
		default.defs || die
}

src_install() {
	dodir /usr/$(get_libdir) /usr/include/pwdb
	emake \
		INCLUDED="${D}"/usr/include/pwdb \
		LIBDIR="${D}"/usr/$(get_libdir) \
		LDCONFIG="echo" \
		install

	gen_usr_ldscript -a pwdb

	insinto /etc
	doins conf/pwdb.conf

	einstalldocs
}
