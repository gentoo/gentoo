# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RMBARKER
MODULE_VERSION=0.113
inherit perl-module

DESCRIPTION="Perl extension for replacing a link by a copy of the linked file"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/perl-File-Spec"
DEPEND="dev-perl/Module-Build
	virtual/perl-File-Temp
	${RDEPEND}"

SRC_TEST="do"

src_test() {
	perl_rm_files t/pod-coverage.t t/pod.t
	perl-module_src_test
}
