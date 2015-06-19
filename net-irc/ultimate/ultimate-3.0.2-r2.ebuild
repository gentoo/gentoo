# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ultimate/ultimate-3.0.2-r2.ebuild,v 1.4 2014/01/08 06:39:09 vapier Exp $

EAPI=4

AT_M4DIR=autoconf
inherit autotools eutils fixheadtails prefix ssl-cert user

MY_P=Ultimate${PV/_/.}

DESCRIPTION="An IRCd server based on DALnet's DreamForge IRCd"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
HOMEPAGE="http://www.shadow-realm.org/"

KEYWORDS="~amd64 ~ppc ~sparc x86 ~amd64-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE="ssl"

RDEPEND="sys-libs/zlib
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -rf zlib || die

	cp "${FILESDIR}"/${P}-config.patch.in "${T}"/${P}-config.patch || die
	eprefixify "${T}"/${P}-config.patch
	epatch "${T}"/${P}-config.patch

	epatch "${FILESDIR}"/${P}-system-zlib-r1.patch
	epatch "${FILESDIR}"/${P}-make-failfast.patch
	epatch "${FILESDIR}"/${P}-open-mode.patch
	epatch "${FILESDIR}"/${P}-entropy-path.patch

	mv autoconf/configure.in ./ || die
	ht_fix_file configure.in
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/ultimateircd \
		--localstatedir="${EPREFIX}"/var/lib/ultimateircd \
		--disable-ccdv \
		$(use_enable ssl openssl)
}

src_compile() {
	# Must rerun the depend stage because we removed the zlib/ dir to
	# which the stale dependencies still refer.
	emake depend
	emake
}

src_install() {
	dodir /etc/ultimateircd
	keepdir /var/{lib,log,run}/ultimateircd

	einstall \
		sysconfdir="${ED}"/etc/ultimateircd \
		localstatedir="${ED}"/var/lib/ultimateircd \
		networksubdir='$(sysconfdir)/networks'

	rm -rf "${ED}"/usr/{{ircd,kill,rehash},bin/{ircdchk,ssl-{cert,search}.sh}} "${ED}"/var/lib/ultimateircd/logs || die
	dosym /var/log/ultimateircd /var/lib/ultimateircd/logs

	mv "${ED}"/usr/bin/ircd "${ED}"/usr/bin/ultimateircd || die
	mv "${ED}"/usr/bin/mkpasswd "${ED}"/usr/bin/ultimateircd-mkpasswd || die

	newinitd "${FILESDIR}"/ultimateircd.rc.2 ultimateircd
	newconfd "${FILESDIR}"/ultimateircd.conf.2 ultimateircd
}

pkg_preinst() {
	if ! use prefix; then
		enewuser ultimateircd
		fowners ultimateircd /var/{lib,log,run}/ultimateircd
		fowners -R ultimateircd /etc/ultimateircd
	fi

	fperms -R go-rwx /etc/ultimateircd
	fperms 0700 /var/{lib,log,run}/ultimateircd
}

pkg_postinst() {
	if use ssl && [[ ! -e ${EROOT}etc/ultimateircd/ircd.crt ]]; then
		install_cert /etc/ultimateircd/ircd
		use prefix || chown ultimateircd "${EROOT}"etc/ultimateircd/ircd.{key,crt,pem}
	fi
}
