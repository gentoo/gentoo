# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="A nice tool to manage amt-enabled machines"
HOMEPAGE="https://www.kraxel.org/blog/linux/amtterm/"
SRC_URI="https://www.kraxel.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="gtk"

DEPEND="gtk? (
	x11-libs/gtk+:3
	x11-libs/vte:2.91 )"
RDEPEND="${DEPEND}
	dev-perl/SOAP-Lite"

src_prepare() {
	sed -i -e 's|\(INSTALL_BINARY  := \$(INSTALL)\) \$(STRIP)|\1|' mk/Variables.mk || die
}

src_configure() {
	echo "LIB := $(get_libdir)" > Make.config || die

	# enable gamt
	echo "HAVE_GTK := $(usex gtk)" >> Make.config || die
	echo "HAVE_VTE := $(usex gtk)" >> Make.config || die
}

src_compile() {
	prefix="/usr" emake
}

src_install() {
	prefix="/usr" emake DESTDIR=${ED} install

	if ! use gtk; then
		rm -rf "${D}"/usr/share/applications || die
		rm -rf "${D}"/usr/share/man/man1/gamt* || die
	fi
}
