# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="HTTP download tool built atop the HTTP fetcher library"
HOMEPAGE="https://sourceforge.net/projects/fetch/"
SRC_URI="mirror://sourceforge/fetch/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-libs/http-fetcher
	!dev-perl/BTLib"

DEPEND="${RDEPEND}"

HTML_DOCS=( docs/fetch.html )

src_prepare() {
	default
	sed -i -e "/^ld_rpath/d" configure || die "sed failed"

	# bug #870499
	eautoreconf
}
