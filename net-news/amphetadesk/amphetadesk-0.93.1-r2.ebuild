# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free syndicated news aggregator"
HOMEPAGE="https://www.disobey.com/amphetadesk/"
SRC_URI="mirror://sourceforge/sourceforge/amphetadesk/${PN}-src-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-src-v${PV}"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="dev-lang/perl
	dev-perl/libwww-perl
	dev-libs/expat
	dev-perl/XML-Parser
	virtual/perl-IO-Compress"

src_install() {
	dodir /usr/share/amphetadesk
	cp "${S}"/AmphetaDesk.pl "${D}"/usr/share/amphetadesk/AmphetaDesk.pl || die
	dodoc README.txt
	cp -R "${S}"/data "${D}"/usr/share/amphetadesk || die
	cp -R "${S}"/docs "${D}"/usr/share/amphetadesk || die
	cp -R "${S}"/lib "${D}"/usr/share/amphetadesk || die
	cp -R "${S}"/templates "${D}"/usr/share/amphetadesk || die
	newinitd "${FILESDIR}"/amphetadesk.initd amphetadesk || die
}

pkg_postinst() {
	# fixes bug #25066 thanks to kloeri
	/etc/init.d/depscan.sh

	einfo "AmphetaDesk should be started and stopped with the runscript located at "
	einfo "'/etc/init.d/amphetadesk'. You can access AmphetaDesk after it has been"
	einfo "started in your browser of choice on port 8888."
	einfo ""
	ewarn "If you start AmphetaDesk at boot with rc-update don't give it a browser"
	ewarn "to start up when it loads (in the options page)"
}
