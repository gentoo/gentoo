# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="http://embed.cs.utah.edu/creduce/"
SRC_URI="http://embed.cs.utah.edu/creduce/${P}.tar.gz"

LICENSE="creduce"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-lang/perl-5.10.0
	app-text/delta
	dev-perl/Benchmark-Timer
	dev-perl/Exporter-Lite
	dev-perl/File-Which
	dev-perl/Getopt-Tabular
	dev-perl/Regexp-Common
	dev-perl/Sys-CPU
	dev-util/astyle
	dev-util/indent
	=sys-devel/clang-3.7*:0=
	=sys-devel/llvm-3.7*:0=[clang]"

RDEPEND="${DEPEND}"
