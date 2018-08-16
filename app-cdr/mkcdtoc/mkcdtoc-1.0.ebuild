# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="command-line utility to create toc-files for cdrdao"
HOMEPAGE="https://sourceforge.net/projects/mkcdtoc/"
SRC_URI="mirror://sourceforge/mkcdtoc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/perl-5.8.0"
RDEPEND="${DEPEND}"
