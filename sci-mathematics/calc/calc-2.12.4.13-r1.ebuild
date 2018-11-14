# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Arbitrary precision C-like arithmetic system"
HOMEPAGE="http://www.isthe.com/chongo/tech/comp/calc/"
SRC_URI="http://www.isthe.com/chongo/src/calc/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE=""

DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.12.4.13-prefix.patch\
		"${FILESDIR}"/2.12.4.0-ldflags.patch
	ln -sf libcustcalc.so.${PV} custom/libcustcalc.so || die
	sed -i -e "/DIR/s:/usr:${EPREFIX}/usr:g" Makefile || die
}

src_compile() {
	# parallel compilation hard to fix. better to leave upstream.
	emake -j1 \
		CC="$(tc-getCC)" \
		DEBUG="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CALCPAGER="${PAGER}" \
		USE_READLINE="-DUSE_READLINE" \
		READLINE_LIB="-lreadline -lhistory -lncurses -L\"${S}\"/custom -lcustcalc" \
		all
}

src_test() {
	if echo "${LD_PRELOAD}" | grep -q "sandbox"; then
		ewarn "Can't run check when running in sandbox - see bug #59676"
	else
		emake chk
	fi
}

src_install() {
	emake \
		T="${D}" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install
	dodoc BUGS CHANGES LIBRARY README
}
