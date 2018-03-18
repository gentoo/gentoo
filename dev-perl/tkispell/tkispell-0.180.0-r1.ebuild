# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RKIES
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Perl/Tk user interface for ispell"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-text/aspell
	dev-perl/Tk
	virtual/perl-Carp
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-0.18-aspell.patch" )

src_test() {
	ebegin "Compile testing Tk::SimpleFileSelect 0.68"
		perl -Mblib="${S}" -M"Tk::SimpleFileSelect 0.68 ()" -e1
	if ! eend $?; then
		echo
		eerror "One or more modules failed compile:";
		eerror "  Tk::SimpleFileSelect 0.68"
		die "Failing due to module compilation errors";
	fi
	perl-module_src_test
}
