# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="RSCHUPP"
DIST_VERSION=1.064
inherit perl-module

DESCRIPTION="PAR Packager"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
		dev-perl/Getopt-ArgvFile
		dev-perl/IPC-Run3
		dev-perl/Module-ScanDeps
		dev-perl/PAR
		virtual/perl-Digest-SHA
"
DEPEND="${RDEPEND}"

src_prepare() {
	# rename pp binary to parp to avoid conflict with dev-libs/nss
	mv script/pp script/parp
	sed -i \
		-e 's#blib/man1/pp.1#blib/man1/parp.1#' \
		-e 's#script/pp#script/parp#' \
		Makefile.PL MANIFEST || die
	# fix tests to match
	sed -i -e 's/blib script pp/blib script parp/' t/utils.pl t/*.t || die
	sed -i -e 's/pp:/parp:/g' contrib/automated_pp_test/automated_pp_test.pl || die
	default
}

src_install() {
	default
	ewarn "/usr/bin/pp has been installed as /usr/bin/parp"
	ewarn "to avoid a name conflict with dev-libs/nss"
}
