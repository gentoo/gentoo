# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Convert CUE files to cdrdao's TOC format"
HOMEPAGE="https://cue2toc.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/cue2toc/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ppc64 ~sparc ~x86"

DEPEND="!!app-cdr/cdrdao"
