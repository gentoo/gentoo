# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A command line source client for Icecast media streaming servers"
HOMEPAGE="https://www.icecast.org/ezstream/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libxml2
	>=media-libs/libshout-2.2
	media-libs/taglib:="
RDEPEND="
	${DEPEND}
	net-misc/icecast"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-libs/check )"

PATCHES=(
	"${FILESDIR}/${P}-conditional-check.patch"
	"${FILESDIR}/${P}-basename-in-libgen.patch"
)

src_prepare() {
	default
	# patching mandatory dependency on libcheck from configure.ac
	eautoreconf
}

src_configure() {
	econf \
		--enable-examplesdir='$(docdir)/examples' \
		$(use_enable test check)
}

src_install() {
	default

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	rm -f "${ED}"/usr/share/doc/${PF}/COPYING || die
}
