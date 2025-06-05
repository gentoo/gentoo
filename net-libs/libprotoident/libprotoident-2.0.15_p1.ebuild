# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="A library that performs application layer protocol identification for flows"
HOMEPAGE="https://github.com/LibtraceTeam/libprotoident"
SRC_URI="https://github.com/LibtraceTeam/${PN}/archive/refs/tags/${PV/_p/-}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${P/_p/-}

LICENSE="LGPL-3+"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs tools"

DEPEND="
	>=net-libs/libtrace-4.0.1
	>=net-libs/libflowmanager-3.0.0
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	# Update README to remove links to dead WAND sites
	"${FILESDIR}"/0001-Update-README-to-remove-links-to-dead-WAND-sites.patch
	)

src_prepare() {
	default

	sed -i \
		-e '/-Werror/d' \
		lib/Makefile.am || die

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
