# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

EGIT_REPO_URI="https://github.com/csmith-project/creduce
	git://github.com/csmith-project/creduce"

inherit autotools git-r3

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="http://embed.cs.utah.edu/creduce/"
SRC_URI=""

LICENSE="creduce"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	>=dev-lang/perl-5.10.0
	>=sys-devel/clang-3.9:="
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

src_prepare() {
	default
	eautoreconf
}
