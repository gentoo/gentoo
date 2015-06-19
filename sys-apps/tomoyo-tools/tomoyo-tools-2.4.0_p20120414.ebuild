# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tomoyo-tools/tomoyo-tools-2.4.0_p20120414.ebuild,v 1.1 2012/06/01 07:56:06 naota Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/52848/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}
	!sys-apps/ccs-tools"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.0_p20110929-flags-parallel.patch

	# Fix libdir
	sed -i \
		-e "s:/usr/lib:/usr/$(get_libdir):g" \
		Include.make || die "sed failed"

	echo "CONFIG_PROTECT=\"/usr/$(get_libdir)/tomoyo/conf\"" > "${T}/50${PN}"

	tc-export CC
}

src_install() {
	dodir /usr/"$(get_libdir)" || die

	emake INSTALLDIR="${D}" install || die

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
