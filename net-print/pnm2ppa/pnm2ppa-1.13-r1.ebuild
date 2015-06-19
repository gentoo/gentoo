# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/pnm2ppa/pnm2ppa-1.13-r1.ebuild,v 1.3 2014/01/05 23:09:48 dilfridge Exp $

EAPI=4

inherit base

DESCRIPTION="Print driver for Hp Deskjet 710, 712, 720, 722, 820, 1000 series"
HOMEPAGE="http://pnm2ppa.sourceforge.net"
SRC_URI="mirror://sourceforge/pnm2ppa/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="syslog"

# en on first place so others can override it
LANGS="en cs es fr it nl"
for lng in ${LANGS}; do
	IUSE+=" linguas_${lng}"
done

RDEPEND="
	app-text/ghostscript-gpl
	net-print/cups
	|| ( >=net-print/cups-filters-1.0.43-r1[foomatic] net-print/foomatic-filters )
	sys-libs/glibc
	syslog? ( virtual/logger )
"
DEPEND="${RDEPEND}"

src_configure() {
	local lng i withval

	for lng in ${LANGS}; do
		if use linguas_${lng}; then
			if [[ -n ${i} ]] ; then
				ewarn "This package supports only one translation at a time."
				ewarn "Overriding previous value: \"${withval}\" with \"${lng}\""
			fi
			withval="${lng}"
			i=true
		fi
	done

	econf \
		--with-language="${lng}" \
		--enable-vlink \
		$(use_enable syslog)
}

src_install() {
	default

	dobin utils/Linux/detect_ppa utils/Linux/test_ppa

	insinto /usr/share/pnm2ppa
	doins -r lpd pdq

	exeinto /usr/share/pnm2ppa/lpd
	doexe lpd/lpdsetup

	exeinto /usr/share/pnm2ppa/sample_scripts
	doexe sample_scripts/*

	exeinto /etc/pdq/drivers/ghostscript
	doexe pdq/gs-pnm2ppa
	exeinto /etc/pdq/interfaces
	doexe pdq/dummy

	# install docs
	cd docs/en
	dodoc CALIBRATION*txt COLOR*txt PPA*txt RELEASE* CREDITS README sgml/*.sgml

	cd "${S}"
	dohtml -r .
}
