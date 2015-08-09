# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="An arbitrary precision C-like arithmetic system"
HOMEPAGE="http://www.isthe.com/chongo/tech/comp/calc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="alpha ~amd64 ~ppc x86"

IUSE=""

DEPEND=">=sys-libs/ncurses-5.2
	>=sys-libs/readline-4.2"

RDEPEND="${DEPEND}
		>=sys-apps/less-348"

src_compile() {
	make \
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
