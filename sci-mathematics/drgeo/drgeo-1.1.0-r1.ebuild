# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DOC="${PN}-doc-1.5"

DESCRIPTION="Interactive geometry package"
HOMEPAGE="http://www.ofset.org/drgeo"
SRC_URI="
	mirror://sourceforge/ofset/${P}.tar.gz
	mirror://sourceforge/ofset/${DOC}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

RDEPEND="
	dev-libs/libxml2:2
	dev-scheme/guile:=[deprecated]
	gnome-base/libglade:2.0
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gcc45.patch )

src_configure() {
	default
	# Can't make the documentation as it depends on Hyperlatex which isn't
	# yet in portage. Fortunately HTML is already compiled for us in the
	# tarball and so can be installed. Just create the make install target.
	cd "${WORKDIR}"/${DOC} || die
	econf
}

src_install() {
	sed -i -e "s/gnome-drgenius.png/${PN}/" \
		-e '/^Categories=/s/Application;//' \
		${PN}.desktop || die
	default
	emake -C "${WORKDIR}"/${DOC}/$(usex nls "" c) DESTDIR="${D}" install
	doicon glade/${PN}.png
}
