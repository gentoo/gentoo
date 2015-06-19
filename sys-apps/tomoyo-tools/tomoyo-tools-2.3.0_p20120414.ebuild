# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tomoyo-tools/tomoyo-tools-2.3.0_p20120414.ebuild,v 1.1 2012/06/01 07:56:06 naota Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/48663/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}
	!sys-apps/ccs-tools"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags-parallel.patch \
		"${FILESDIR}"/${PN}-2.3.0_p20110929-gentoo.patch

	# Fix libdir
	sed -i \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		Include.make || die "sed failed"

	echo "CONFIG_PROTECT=\"/usr/$(get_libdir)/tomoyo/conf\"" > "${T}/50${PN}"
}

src_install() {
	dodir /usr/"$(get_libdir)" || die

	emake INSTALLDIR="${D}" install || die

	# Move-link tomoyotools.conf to subdir "conf"
	rm "${D}"/usr/$(get_libdir)/tomoyo/tomoyotools.conf || die
	insinto /usr/$(get_libdir)/tomoyo/conf
	doins usr_lib_tomoyo/tomoyotools.conf || die
	dosym conf/tomoyotools.conf /usr/$(get_libdir)/tomoyo/tomoyotools.conf || die

	doenvd "${T}/50${PN}" || die

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
