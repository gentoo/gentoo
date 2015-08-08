# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
MODULE_AUTHOR=ISHIGAKI
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION='do use_ok() for all the MANIFESTed modules'

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
perl_meta_configure() {
	# ExtUtils::MakeMaker
	echo virtual/perl-ExtUtils-MakeMaker
}
perl_meta_build() {
	# ExtUtils::MakeMaker
	echo virtual/perl-ExtUtils-MakeMaker
}
perl_meta_runtime() {
	# Exporter
	echo virtual/perl-Exporter
	# ExtUtils::Manifest
	echo virtual/perl-ExtUtils-Manifest
	# Test::Builder 0.30 ( 0.300.0 )
	echo \>=virtual/perl-Test-Simple-0.30
	# Test::More 0.60 ( 0.600.0 )
	echo \>=virtual/perl-Test-Simple-0.60
}
DEPEND="
	$(perl_meta_configure)
	$(perl_meta_build)
	$(perl_meta_runtime)
"
RDEPEND="
	$(perl_meta_runtime)
"
