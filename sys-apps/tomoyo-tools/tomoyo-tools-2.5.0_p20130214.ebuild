# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tomoyo-tools/tomoyo-tools-2.5.0_p20130214.ebuild,v 1.2 2014/11/23 10:09:06 jer Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/53357/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="sys-libs/ncurses"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/ccs-tools"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-warnings.patch

	# Fix libdir
	sed -i \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		Include.make || die

	# tinfo
	sed -i \
		-e 's|-lncurses|$(shell ${PKG_CONFIG} --libs ncurses)|g' \
		usr_sbin/Makefile || die

	echo "CONFIG_PROTECT=\"/usr/$(get_libdir)/tomoyo/conf\"" > "${T}/50${PN}"

	tc-export CC PKG_CONFIG
}

src_install() {
	dodir /usr/"$(get_libdir)"

	emake INSTALLDIR="${D}" install

	doenvd "${T}/50${PN}"

	# Fix out-of-place readme and license
	rm "${D}"/usr/$(get_libdir)/tomoyo/{COPYING.tomoyo,README.tomoyo} || die
	dodoc README.tomoyo || die
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
	/usr/$(get_libdir)/tomoyo/init_policy
}
