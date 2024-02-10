# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Arbitrary precision C-like arithmetic system"
HOMEPAGE="http://www.isthe.com/chongo/tech/comp/calc/"
SRC_URI="http://www.isthe.com/chongo/src/calc/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.13.0.1-RPATH.patch
	"${FILESDIR}"/${PN}-2.13.0.1-respect-LDFLAGS.patch
)

src_prepare() {
	default

	ln -sf libcustcalc.so.${PV} custom/libcustcalc.so || die
	sed -i -e "/DIR/s:/usr:${EPREFIX}/usr:g" Makefile || die
}

src_compile() {
	# parallel compilation hard to fix. better to leave upstream.
	emake -j1 \
		CC="$(tc-getCC)" \
		DEBUG="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		EXTRA_LDFLAGS="${LDFLAGS}" \
		CALCPAGER="${PAGER}" \
		USE_READLINE="-DUSE_READLINE" \
		READLINE_LIB="-lreadline -lhistory $($(tc-getPKG_CONFIG) --libs ncurses) -L\"${S}\"/custom -lcustcalc" \
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

	dodoc BUGS CHANGES LIBRARY
}
