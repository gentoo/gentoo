# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Rezlooks GTK+ Engine"
HOMEPAGE="https://www.gnome-look.org/content/show.php?content=39179"
SRC_URI="https://www.gnome-look.org/content/files/39179-rezlooks-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/rezlooks-${PV}

PATCHES=( "${FILESDIR}"/${PN}-0.6-glib-single-include.patch )

src_prepare() {
	default

	# automake complains: ChangeLog missing. There however is a Changelog.
	# to avoid problems with case insensitive fs, move somewhere else first.
	mv Changelog{,.1} || die
	mv Changelog.1 ChangeLog || die

	eautoreconf # required for interix
}

src_configure() {
	econf --enable-animation
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
