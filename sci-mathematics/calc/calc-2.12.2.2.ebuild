# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

DESCRIPTION="An arbitrary precision C-like arithmetic system"
HOMEPAGE="http://www.isthe.com/chongo/tech/comp/calc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~x86"

IUSE=""

DEPEND=">=sys-libs/ncurses-5.2
	>=sys-libs/readline-4.2"

RDEPEND="${DEPEND}
		>=sys-apps/less-348"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-libdir-fix.patch

	sed -e "s:LIBDIR= /usr/lib:LIBDIR= /usr/$(get_libdir):" \
		-i Makefile || die "Failed to fix multilib in makefile"
}

src_compile() {
	# bug #299224
	emake -j1 \
		T="${D}" \
		DEBUG="${CFLAGS}" \
		CALCPAGER=less \
		USE_READLINE="-DUSE_READLINE" \
		READLINE_LIB="-lreadline -lhistory -lncurses" \
		all \
	|| die
	if echo "${LD_PRELOAD}" | grep -q "sandbox"; then
		ewarn "Can't run check when running in sandbox - see bug #59676"
	else
		make chk || die "Check failed"
	fi
}

src_install() {
	make T="${D}" install || die
	dodoc BUGS CHANGES LIBRARY README
}
