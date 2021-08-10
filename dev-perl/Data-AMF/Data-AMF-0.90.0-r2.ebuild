# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TYPESTER
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="(de)serializer perl module for Adobe's AMF (Action Message Format)"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/DateTime
	dev-perl/Any-Moose
	dev-perl/UNIVERSAL-require
	dev-perl/XML-LibXML"

BDEPEND="${RDEPEND}
	test? (
		dev-perl/YAML
		dev-perl/Spiffy
		dev-perl/Test-Base
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	"inc/YAML.pm"
	"inc/Spiffy.pm"
	"inc/Test/More.pm"
	"inc/Test/Base.pm"
	"inc/Test/Builder.pm"
	"inc/Test/Base/Filter.pm"
	"inc/Test/Builder/Module.pm"
)
PATCHES=(
	"${FILESDIR}/${PN}-0.09-no-dot-inc.patch"
)
