# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="ZEFRAM"
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION="details of the floating point data type"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-parent"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"

src_test() {
	perl_rm_files "t/pod_syn.t" "t/pod_cvg.t"
	perl-module_src_test
}
