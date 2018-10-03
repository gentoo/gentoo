# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

SNAPSHOTDATE="${PV##*.}"
MY_P="${PN}-${SNAPSHOTDATE}"

DESCRIPTION="GNUCap is the GNU Circuit Analysis Package"
SRC_URI="http://git.savannah.gnu.org/cgit/${PN}.git/snapshot/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnucap.org/"

IUSE="+models +readline"
SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="readline? ( sys-libs/readline:0= )"
RDEPEND="${DEPEND}"
PDEPEND="models? ( ~sci-electronics/gnucap-models-${PV} )"

S="${WORKDIR}"/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-0.36.20171003-readline.patch )

src_prepare() {
	default

	sed -i -e 's:echo "-DUNIX -O2:echo "-DUNIX:' \
		-e 's:LDFLAGS =:LDFLAGS +=:' \
		*/configure || die "sed failed"

	sed -i -e 's:$prefix/lib:$prefix/${LIBDIR}:g' \
		-e '/#@sysconfdir@#/s:$\\{prefix\\}::' \
		main/configure || die "sed failed"

	sed -i -e '/INSTALL_DIR/s:lib:${LIBDIR}:' \
		-e '/INSTALL_SYSCONF_DIR/s:$(PREFIX)::' \
		*/Make1 || die "sed failed"

	sed -i -e 's:-DUNIX -O3 -DNDEBUG:-DUNIX -DNDEBUG:' \
		-e 's:LDFLAGS =:LDFLAGS +=:' \
		*/Make2.g++ || die "sed failed"

	tc-export CXX
	export CCFLAGS="${CXXFLAGS}" LIBDIR="$(get_libdir)"
}

src_configure() {
	USE_READLINE=$(usex readline) \
	econf
}

src_compile () {
	emake CCC="$(tc-getCXX)"
}

pkg_postinst() {
	elog "Documentation for development releases is now available at :"
	elog "    http://www.gnucap.org/dokuwiki/doku.php/gnucap:manual"
}
