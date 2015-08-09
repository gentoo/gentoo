# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="C-Reduce - a plugin-based C program reducer"
HOMEPAGE="http://embed.cs.utah.edu/creduce/"
SRC_URI="http://embed.cs.utah.edu/creduce/${P}.tar.gz"

LICENSE="creduce"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-lang/perl-5.10.0
	<sys-devel/clang-3.2
	<sys-devel/llvm-3.2"

RDEPEND="${DEPEND}
	app-text/delta
	dev-perl/Exporter-Lite
	dev-perl/File-Which
	dev-perl/regexp-common
	dev-util/astyle
	dev-util/indent"
