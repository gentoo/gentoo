# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

: ${CMAKE_MAKEFILE_GENERATOR=ninja}
inherit cmake-utils llvm

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="http://embed.cs.utah.edu/creduce/"
SRC_URI="http://embed.cs.utah.edu/creduce/${P}.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	>=dev-lang/perl-5.10.0
	<sys-devel/clang-5:=
	|| (
		sys-devel/clang:4
		>=sys-devel/clang-3.9:0
	)"
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

LLVM_MAX_SLOT=4
