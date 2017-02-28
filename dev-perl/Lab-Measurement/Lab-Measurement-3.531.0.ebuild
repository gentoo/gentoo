# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ "${PV}" != "9999" ]]; then
	DIST_VERSION=3.531
	DIST_AUTHOR="AKHUETTEL"
	KEYWORDS="~amd64 ~x86"
	inherit perl-module
else
	EGIT_REPO_URI="https://github.com/lab-measurement/lab-measurement.git"
	EGIT_BRANCH="master"
	inherit perl-module git-r3
	S=${WORKDIR}/${P}/Measurement
fi

DESCRIPTION="Measurement control and automation with Perl"
HOMEPAGE="http://www.labmeasurement.de/"

SLOT="0"
IUSE="test +xpression"

RDEPEND="
	dev-perl/Class-ISA
	>=dev-perl/Class-Method-Modifiers-2.110.0
	>=dev-perl/Clone-0.310.0
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	>=dev-perl/Exception-Class-1
	dev-perl/Hook-LexWrap
	dev-perl/List-MoreUtils
	>=dev-perl/Moose-2.121.300
	>=dev-perl/MooseX-Params-Validate-0.180.0
	>=dev-perl/namespace-autoclean-0.200.0
	>=dev-perl/Role-Tiny-1.3.4
	dev-perl/Statistics-Descriptive
	dev-perl/Term-ANSIScreen
	>=dev-perl/TermReadKey-2.320.0
	dev-perl/TeX-Encode
	virtual/perl-Time-HiRes
	>=dev-perl/Try-Tiny-0.220.0
	dev-perl/XML-DOM
	dev-perl/XML-Generator
	dev-perl/XML-Twig
	dev-perl/YAML
	dev-perl/aliased
	>=dev-perl/YAML-LibYAML-0.410.0
	sci-visualization/gnuplot
	!dev-perl/Lab-Instrument
	!dev-perl/Lab-Tools
	xpression? (
		dev-perl/Wx
	)
"
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/File-Slurper
		dev-perl/Test-Files
		>=dev-perl/Test-Fatal-0.12.0
	)
"

pkg_postinst() {
	if ( ! has_version sci-libs/linuxgpib ) && ( ! has_version dev-perl/Lab-VISA ) ; then
		elog "You may want to install one or more backend driver modules. Supported are"
		elog "    sci-libs/linuxgpib    Open-source GPIB hardware driver"
		elog "    dev-perl/Lab-VISA     Bindings for the NI proprietary VISA driver"
		elog "                          stack (dilfridge overlay)"
	fi
}
