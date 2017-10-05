# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=ZEFRAM
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="dynamic class mixing"
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Params-Classify
	virtual/perl-Exporter
	virtual/perl-if
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/pod_cvg.t t/pod_syn.t
	perl-module_src_test
}
