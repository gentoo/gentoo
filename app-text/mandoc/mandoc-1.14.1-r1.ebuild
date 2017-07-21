# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_PN="mdocml"
MY_P="${MY_PN}-${PV}"

inherit multilib toolchain-funcs

DESCRIPTION="Suite of tools compiling mdoc and man"
HOMEPAGE="http://mdocml.bsd.lv/"
SRC_URI="http://mdocml.bsd.lv/snapshots/${MY_P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sqlite static"

LIB_DEPEND="sys-libs/zlib[static-libs(+)]
	sqlite? ( dev-db/sqlite:3[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# The db-install change is to support parallel installs.
	sed -i \
		-e '/ar rs/s:ar:$(AR):' \
		-e '/^db-install:/s:$: base-install:' \
		Makefile || die

	cat <<EOF > "configure.local"
PREFIX="${EPREFIX}/usr"
BINDIR="${EPREFIX}/usr/bin"
SBINDIR="${EPREFIX}/usr/sbin"
LIBDIR="${EPREFIX}/usr/$(get_libdir)"
MANDIR="${EPREFIX}/usr/share/man"
INCLUDEDIR="${EPREFIX}/usr/include/mandoc"
EXAMPLEDIR="${EPREFIX}/usr/share/examples/mandoc"
MANPATH_DEFAULT="${EPREFIX}/usr/man:${EPREFIX}/usr/share/man:${EPREFIX}/usr/local/man:${EPREFIX}/usr/local/share/man"

BINM_MAN=mman
BINM_SOELIM=msoelim
BINM_APROPOS=mapropos
BINM_WHATIS=mwhatis
BINM_MAKEWHATIS=mmakewhatis
MANM_MAN=mandoc_man
MANM_MDOC=mandoc_mdoc
MANM_ROFF=mandoc_roff
MANM_EQN=mandoc_eqn
MANM_TBL=mandoc_tbl
MANM_MANCONF=mman.conf

HAVE_SQLITE3="$(usex sqlite 1 0)"

CFLAGS="${CFLAGS} ${CPPFLAGS}"
LDFLAGS="${LDFLAGS} $(usex static -static '')"
AR="$(tc-getAR)"
CC="$(tc-getCC)"
# The STATIC variable is only used by man.cgi.
STATIC=
EOF
}
