# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Mister House, an open source home automation program with X10 support"
HOMEPAGE="http://misterhouse.sf.net/"
LICENSE="GPL-1"
SRC_URI="mirror://sourceforge/misterhouse/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tk mysql"

S="${WORKDIR}/mh"

RDEPEND="dev-lang/perl
	tk? ( dev-perl/Tk
		dev-perl/Tk-CursorControl )
	mysql? ( dev-perl/DBD-mysql )
	|| ( app-accessibility/festival
		app-accessibility/flite )
	dev-perl/GD
	virtual/perl-DB_File
	dev-perl/TermReadKey
	virtual/perl-Time-HiRes
	dev-perl/Audio-Mixer
	dev-perl/Text-LevenshteinXS"

src_install() {
	dodir /opt/misterhouse

	cp -r "${S}/bin" "${D}/opt/misterhouse" || die
	cp -r "${S}/code" "${D}/opt/misterhouse" || die
	cp -r "${S}/data" "${D}/opt/misterhouse" || die
	for a in "${S}"/docs/*; do
		dodoc ${a} || die
	done
	dosym /usr/share/doc/${PF} /opt/misterhouse/docs
	cp -r "${S}/lib" "${D}/opt/misterhouse" || die
	cp -r "${S}/sounds" "${D}/opt/misterhouse" || die
	cp -r "${S}/web" "${D}/opt/misterhouse" || die
	newconfd "${FILESDIR}"/misterhouse.conf misterhouse
	newinitd "${FILESDIR}"/misterhouse.init misterhouse

}

pkg_postinst() {
	cd /opt/misterhouse/bin
	./configure
}
