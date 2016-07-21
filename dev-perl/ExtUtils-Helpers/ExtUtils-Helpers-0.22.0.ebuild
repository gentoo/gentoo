# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
MODULE_AUTHOR=LEONT
MODULE_VERSION=0.022
inherit perl-module

DESCRIPTION='Various portability utilities for module builders'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ~ppc64 ~sparc x86"
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
