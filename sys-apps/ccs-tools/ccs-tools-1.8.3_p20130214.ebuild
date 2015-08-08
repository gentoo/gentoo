# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit eutils multilib toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/49693/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

DEPEND="sys-libs/ncurses
	sys-libs/readline"
RDEPEND="${DEPEND}
	sys-apps/which"

S="${WORKDIR}/ccs-tools"

src_prepare() {
	epatch "${FILESDIR}"/${P}-warnings.patch
	sed -i \
		-e "s:gcc:$(tc-getCC):" \
		-e "s/\(CFLAGS.*:=\).*/\1 ${CFLAGS}/" \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		-e "s:= /:= ${EPREFIX}/:g" \
		Include.make || die
}

src_test() {
	cd "${S}/kernel_test"
	emake || die
	./testall.sh || die
}

src_install() {
	emake INSTALLDIR="${D}" install || die
	dodoc README.ccs
}

pkg_postinst() {
	elog "Execute the following command to setup the initial policy configuration:"
	elog
	elog "emerge --config =${CATEGORY}/${PF}"
	elog
	elog "For more information, please visit http://tomoyo.sourceforge.jp/1.8/"
	elog
	elog "This tools are for ccs-patch'ed kernels. There are also sys-apps/tomoyo-tools"
	elog "which works with TOMOYO 2.x.x versions (already merged into Linux kernel)."
	elog "If you'd like to try them, please emerge sys-apps/tomoyo-tools instead."
}

pkg_config() {
	/usr/$(get_libdir)/ccs/init_policy
}
