# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Convert CUE files to cdrdao's TOC format"
HOMEPAGE="https://cue2toc.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/cue2toc/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="!!app-cdr/cdrdao"

src_prepare() {
	default

	#bug https://bugs.gentoo.org/900128, implicit defines in configure
	eautoreconf
}
