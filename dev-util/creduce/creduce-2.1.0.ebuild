# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/creduce/creduce-2.1.0.ebuild,v 1.1 2014/01/18 03:37:42 dirtyepic Exp $

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
	dev-perl/regexp-common
	dev-perl/Sys-CPU
	dev-util/astyle
	dev-util/indent
	sys-devel/clang:0/3.3
	sys-devel/llvm:0/3.3[clang]"

RDEPEND="${DEPEND}"
