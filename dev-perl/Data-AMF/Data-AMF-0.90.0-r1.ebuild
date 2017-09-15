# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TYPESTER
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="(de)serializer perl module for Adobe's AMF (Action Message Format)"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-perl/DateTime
	dev-perl/Any-Moose
	dev-perl/UNIVERSAL-require
	dev-perl/XML-LibXML"

DEPEND="${RDEPEND}
	test? ( dev-perl/YAML )"

src_prepare() {
	sed -i '/^inc\/YAML.pm/d' MANIFEST || die
	rm inc/YAML.pm || die
	sed -i -e 's/use inc::Module::Install;/use lib q[.];\nuse inc::Module::Install;/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}

SRC_TEST="do"
