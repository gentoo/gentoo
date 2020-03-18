# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop

DESCRIPTION="Fly a plane around bomb/shoot the enemy. Port of Planegame from Amiga"
HOMEPAGE="http://www.fishies.org.uk/apricots.html"
SRC_URI="http://www.fishies.org.uk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video]
	media-libs/openal
	media-libs/freealut"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-freealut.patch \
		"${FILESDIR}"/${P}-ldflags.patch

	cp admin/acinclude.m4.in acinclude.m4

	sed -i \
		-e 's:-DAP_PATH=\\\\\\"$prefix.*":-DAP_PATH=\\\\\\"/usr/share/${PN}/\\\\\\"":' \
		-e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' \
		configure.in || die
	sed -i \
		-e "s:filename(AP_PATH):filename(\"/etc/${PN}/\"):" \
		${PN}/init.cpp || die
	sed -i \
		-e "s:apricots.cfg:/etc/${PN}/apricots.cfg:" \
		README apricots.html || die
	sed -i \
		-e 's/-Wmissing-prototypes//' \
		acinclude.m4 || die

	mv configure.in configure.ac || die
	eautoreconf
}

src_compile() {
	emake LIBTOOL="/usr/bin/libtool"
}

src_install() {
	HTML_DOCS="apricots.html"
	einstalldocs

	cd ${PN}
	dobin apricots
	insinto /usr/share/${PN}
	doins *.wav *.psf *.shapes
	insinto /etc/${PN}
	doins apricots.cfg

	make_desktop_entry ${PN} Apricots
}
