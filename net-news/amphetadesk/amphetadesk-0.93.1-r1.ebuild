# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AmphetaDesk is a free syndicated news aggregator"
HOMEPAGE="http://www.disobey.com/amphetadesk/"
SRC_URI="mirror://sourceforge/sourceforge/amphetadesk/${PN}-src-v${PV}.tar.gz"
S="${WORKDIR}"/${PN}-src-v${PV}

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="dev-lang/perl
	dev-libs/expat
	dev-perl/libwww-perl
	dev-perl/XML-Parser
	virtual/perl-IO-Compress"

src_install() {
	insinto /usr/share/amphetadesk
	doins "${S}"/AmphetaDesk.pl
	doins -R "${S}"/{data,docs,lib,templates}

	dodoc README.txt
	newinitd "${FILESDIR}"/amphetadesk.initd amphetadesk
}

pkg_postinst() {
	# fixes bug #25066 thanks to kloeri
	[[ -x /etc/init.d/depscan.sh ]] && /etc/init.d/depscan.sh

	einfo "AmphetaDesk should be started and stopped with the runscript located at "
	einfo "'/etc/init.d/amphetadesk'. You can access AmphetaDesk after it has been"
	einfo "started in your browser of choice on port 8888."
	einfo ""
	ewarn "If you start AmphetaDesk at boot with rc-update don't give it a browser"
	ewarn "to start up when it loads (in the options page)"
}
