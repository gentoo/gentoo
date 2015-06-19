# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tomoyo-tools/tomoyo-tools-2.2.0_p20120414.ebuild,v 1.1 2012/06/01 07:56:06 naota Exp $

inherit eutils multilib toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/41908/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}
	!sys-apps/ccs-tools"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-ldflags.patch"

	sed -i \
		-e "/^CC/s:gcc:$(tc-getCC):" \
		-e "/^CFLAGS/s:-O2:${CFLAGS}:" \
		-e "/^USRLIBDIR/s:/usr/lib:/usr/$(get_libdir):g" \
		Include.make || die

	echo "CONFIG_PROTECT=\"/usr/$(get_libdir)/tomoyo/conf\"" > "${T}/50${PN}"
}

src_install() {
	emake INSTALLDIR="${D}" install || die

	rm "${D}"/usr/$(get_libdir)/tomoyo/{COPYING.tomoyo,README.tomoyo,tomoyotools.conf} || die
	insinto /usr/$(get_libdir)/tomoyo/conf
	doins tomoyotools.conf || die
	dosym conf/tomoyotools.conf /usr/$(get_libdir)/tomoyo/tomoyotools.conf || die

	doenvd "${T}/50${PN}" || die

	dodoc README.tomoyo
}

pkg_postinst() {
	elog "Execute the following command to setup the initial policy configuration:"
	elog
	elog "emerge --config =${CATEGORY}/${PF}"
	elog
	elog "For more information, please visit the following."
	elog
	elog "http://tomoyo.sourceforge.jp/"
}

pkg_config() {
	/usr/$(get_libdir)/tomoyo/tomoyo_init_policy
}
