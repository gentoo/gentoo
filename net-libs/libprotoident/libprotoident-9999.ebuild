# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="A library that performs application layer protocol identification for flows"
HOMEPAGE="https://research.wand.net.nz/software/libprotoident.php"
EGIT_REPO_URI="https://github.com/wanduow/libprotoident"
EGIT_BRANCH="develop"

LICENSE="LGPL-3+"
SLOT="0/2"
KEYWORDS=""
IUSE="static-libs +tools"

DEPEND="
	>=net-libs/libtrace-4.0.1
	>=net-libs/libflowmanager-3.0.0
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default

	sed -i -e '/-Werror/d' lib/Makefile.am || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
