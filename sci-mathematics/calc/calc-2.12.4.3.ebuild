# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils multilib toolchain-funcs

DESCRIPTION="An arbitrary precision C-like arithmetic system"
HOMEPAGE="http://www.isthe.com/chongo/tech/comp/calc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

IUSE=""

DEPEND="
	>=sys-libs/ncurses-5.2
	>=sys-libs/readline-4.2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.12.4.0-prefix.patch
	epatch "${FILESDIR}"/2.12.4.0-ldflags.patch
	ln -sf libcustcalc.so.${PV} custom/libcustcalc.so
}

src_compile() {
	# parallel compilation hard to fix. better to leave upstream.
	emake -j1 \
		CC=$(tc-getCC) \
		DEBUG="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CALCPAGER="${PAGER}" \
		USE_READLINE="-DUSE_READLINE" \
		READLINE_LIB="-lreadline -lhistory -lncurses -L${S}/custom -lcustcalc" \
		all || die "emake failed"
}

src_test() {
	if echo "${LD_PRELOAD}" | grep -q "sandbox"; then
		ewarn "Can't run check when running in sandbox - see bug #59676"
	else
		make chk || die "Check failed"
	fi
}

src_install() {
	emake T="${D}" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install || die "emake install failed"
	dodoc BUGS CHANGES LIBRARY README
}
