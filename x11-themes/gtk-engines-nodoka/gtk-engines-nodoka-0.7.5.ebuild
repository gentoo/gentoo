# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="gtk-nodoka-engine-${PV}"

DESCRIPTION="GTK+ engine and themes developed by the Fedora Project"
HOMEPAGE="https://fedorahosted.org/nodoka/"
SRC_URI="https://fedorahosted.org/releases/n/o/nodoka/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="animation-rtl"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-glib2.32.patch )

src_configure() {
	econf \
		--enable-animation \
		$(use_enable animation-rtl animationtoleft)
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
