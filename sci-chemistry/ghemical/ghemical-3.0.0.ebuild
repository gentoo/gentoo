# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop

DESCRIPTION="Chemical quantum mechanics and molecular mechanics"
HOMEPAGE="http://bioinformatics.org/ghemical/"
SRC_URI="http://bioinformatics.org/ghemical/download/current/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openbabel seamonkey threads"

RDEPEND="
	dev-libs/glib:2
	gnome-base/libglade:2.0
	sci-chemistry/mpqc
	>=sci-libs/libghemical-3.0.0
	>=x11-libs/liboglappth-1.0.0
	virtual/opengl
	x11-libs/pango
	x11-libs/gtk+:2
	x11-libs/gtkglext
	openbabel? ( sci-chemistry/openbabel )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/2.99.2-docs.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# With amd64, if you want gamess I recommend adding gamess and gtk-gamess to package.provided for now.

	# Change the built-in help browser.
	if use seamonkey ; then
		sed -i -e 's|mozilla|seamonkey|g' src/gtk_app.cpp || die "sed failed for seamonkey!"
	else
		sed -i -e 's|mozilla|firefox|g' src/gtk_app.cpp || die "sed failed for firefox!"
	fi

	econf \
		$(use_enable openbabel) \
		$(use_enable threads)
}

src_install() {
	emake DESTDIR="${D}" install
	make_desktop_entry /usr/bin/ghemical Ghemical /usr/share/ghemical/${PV}/pixmaps/ghemical.png
}
