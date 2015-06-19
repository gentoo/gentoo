# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/silc-server/silc-server-1.1.18.ebuild,v 1.2 2014/01/08 06:41:24 vapier Exp $

EAPI=5

inherit eutils flag-o-matic user

DESCRIPTION="Server for Secure Internet Live Conferencing"
SRC_URI="http://www.silcnet.org/download/server/sources/${P}.tar.bz2"
HOMEPAGE="http://silcnet.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="gmp ipv6 debug"

RDEPEND="!<=net-im/silc-toolkit-0.9.12-r1
	!<=net-im/silc-client-1.0.1
	gmp? ( dev-libs/gmp )"

pkg_setup() {
	enewuser silcd
}

src_configure() {
	econf \
		--datadir=/usr/share/${PN} \
		--datarootdir=/usr/share/${PN} \
		--mandir=/usr/share/man \
		--sysconfdir=/etc/silc \
		--libdir=/usr/$(get_libdir)/${PN} \
		--docdir=/usr/share/doc/${PF} \
		--disable-optimizations \
		--with-logsdir=/var/log/${PN} \
		--with-silcd-pid-file=/var/run/silcd.pid \
		$(use_with gmp) \
		$(use_enable ipv6) \
		$(use_enable debug)
}

#src_compile() {
#	emake -j1
#}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/silc
	doins doc/silcalgs.conf

	insinto /usr/share/doc/${PF}/examples
	doins doc/examples/*.conf

	fperms 600 /etc/silc
	keepdir /var/log/${PN}

	rm -rf \
		"${D}"/usr/libsilc* \
		"${D}"/usr/include \
		"${D}"/etc/silc/silcd.{pub,prv}

	newinitd "${FILESDIR}/silcd.initd-r1" silcd
	doman doc/silcd.8 doc/silcd.conf.5

	sed -i \
		-e 's:10.2.1.6:0.0.0.0:' \
		-e 's:User = "nobody";:User = "silcd";:' \
		-e 's:/var/run:/run:' \
		-e 's:lassi.kuo.fi.ssh.com:localhost:' \
		doc/example_silcd.conf \
		|| die
	dodoc doc/example_silcd.conf
}

pkg_postinst() {
	if [ ! -f "${ROOT}"/etc/silc/silcd.prv ] ; then
		einfo "Creating key pair in /etc/silc"
		silcd -C "${ROOT}"/etc/silc
		chmod 600 "${ROOT}"/etc/silc/silcd.{prv,pub}
	fi
}
