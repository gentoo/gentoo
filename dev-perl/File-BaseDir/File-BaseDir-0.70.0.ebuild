# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KIMRYAN
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Use the Freedesktop.org base directory specification"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Spec
	dev-perl/IPC-System-Simple
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/File-Which
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
DIST_TEST="do" # https://rt.cpan.org/Ticket/Display.html?id=119256
src_test() {
	perl_rm_files t/05_pod_cover.t t/04_pod_ok.t
	perl-module_src_test
}
