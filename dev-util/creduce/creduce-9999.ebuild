# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

EGIT_REPO_URI="https://github.com/csmith-project/creduce
	git://github.com/csmith-project/creduce"

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
inherit cmake-utils git-r3

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="http://embed.cs.utah.edu/creduce/"
SRC_URI=""

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	>=dev-lang/perl-5.10.0
	>=sys-devel/clang-4:="
RDEPEND="${COMMON_DEPEND}
	dev-perl/Benchmark-Timer
	dev-perl/Exporter-Lite
	dev-perl/File-Which
	dev-perl/Getopt-Tabular
	dev-perl/Regexp-Common
	dev-perl/Sys-CPU
	dev-util/astyle
	dev-util/indent"
DEPEND="${COMMON_DEPEND}"
