# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mlmmj/mlmmj-1.2.17.1.ebuild,v 1.4 2010/09/11 21:49:40 josejx Exp $

inherit eutils

MY_PV="${PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Mailing list managing made joyful"
HOMEPAGE="http://mlmmj.org/"
SRC_URI="http://mlmmj.org/releases/${MY_P}.tar.bz2"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""
DEPEND="virtual/mta"
#RDEPEND=""
S="${WORKDIR}/${MY_P}"
SHAREDIR="/usr/share/mlmmj"

src_unpack() {
	unpack ${A}
	#epatch "${FILESDIR}"/${PN}-1.2.16-requeue-unlink-fix.patch
	#epatch "${FILESDIR}"/${PN}-1.2.16-unsub-digest-text.patch
	cd "${S}"
	for i in "${S}" "${S}"/contrib/recievestrip ; do
		pushd "${i}"
		# Ignore errors
		emake -j1 distclean 2>/dev/null 1>/dev/null
		popd
	done
}

src_compile() {
	econf
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die

	dodir ${SHAREDIR}
	dodir ${SHAREDIR}/texts
	insinto ${SHAREDIR}/texts
	doins listtexts/*

	dodoc AUTHORS ChangeLog FAQ README
	dodoc TODO TUNABLES UPGRADE VERSION README.access
	dodoc README.sendmail README.exim4 README.security

	insinto /usr/share/mlmmj
	cd "${S}"/contrib/web
	doins -r *

	dobin "${S}"/contrib/recievestrip
}

pkg_postinst() {
	elog "mlmmj comes with serveral webinterfaces:"
	elog "- One for user subscribing/unsubscribing"
	elog "- One for admin tasks"
	elog "both available in a php and perl module."
	elog "For more info have a look in /usr/share/mlmmj"
}
