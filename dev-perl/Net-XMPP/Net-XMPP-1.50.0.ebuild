# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=DAPATRICK
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="XMPP Perl Library"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test examples"

RDEPEND="
	>=dev-perl/Authen-SASL-2.120.0
	virtual/perl-Digest-SHA
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-Stream-1.240.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.300
	test? (
		>=dev-perl/LWP-Online-1.70.0
		>=dev-perl/YAML-Tiny-1.410.0
		>=virtual/perl-Test-Simple-0.920.0
	)
"
src_test() {
	eapply "${FILESDIR}/${DIST_VERSION}-no-network-tests.patch"
	perl-module_src_test
}

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
