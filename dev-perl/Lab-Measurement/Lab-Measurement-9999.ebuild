# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ "${PV}" != "9999" ]]; then
	MODULE_VERSION=9999 # change this!!!
	MODULE_AUTHOR="AKHUETTEL"
	KEYWORDS="~amd64 ~x86"
	inherit perl-module
else
	EGIT_REPO_URI="https://github.com/lab-measurement/lab-measurement.git"
	EGIT_BRANCH="master"
	S=${WORKDIR}/${P}/Measurement
	inherit perl-module git-r3
fi

DESCRIPTION="Measurement control and automation with Perl"
HOMEPAGE="http://www.labmeasurement.de/"

SLOT="0"
IUSE="debug +xpression"

RDEPEND="
	dev-perl/Class-ISA
	dev-perl/Clone
	dev-perl/Exception-Class
	dev-perl/Hook-LexWrap
	dev-perl/List-MoreUtils
	dev-perl/Term-ANSIScreen
	dev-perl/TermReadKey
	dev-perl/TeX-Encode
	dev-perl/XML-Generator
	dev-perl/XML-DOM
	dev-perl/XML-Twig
	dev-perl/encoding-warnings
	dev-perl/yaml
	dev-perl/Switch
	sci-visualization/gnuplot
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	virtual/perl-Time-HiRes
	!dev-perl/Lab-Instrument
	!dev-perl/Lab-Tools
	debug? (
		dev-lang/perl[ithreads]
		dev-perl/wxperl
	)
	xpression? (
		dev-perl/wxperl
	)
"
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
"

pkg_postinst() {
	if ( ! has_version sci-libs/linuxgpib ) && ( ! has_version dev-perl/Lab-VISA ) ; then
		elog "You may want to install one or more backend driver modules. Supported are"
		elog "    sci-libs/linuxgpib    Open-source GPIB hardware driver"
		elog "    dev-perl/Lab-VISA     Bindings for the NI proprietary VISA driver"
		elog "                          stack (dilfridge overlay)"
	fi
}
