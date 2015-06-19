# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-Helpers/ExtUtils-Helpers-0.22.0.ebuild,v 1.5 2015/05/20 04:48:19 mattst88 Exp $
EAPI=5
MODULE_AUTHOR=LEONT
MODULE_VERSION=0.022
inherit perl-module

DESCRIPTION='Various portability utilities for module builders'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND="
	${RDEPEND}
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-File-Spec
	>=virtual/perl-Text-ParseWords-3.240.0
	virtual/perl-Module-Load
"
SRC_TEST="do parallel"
