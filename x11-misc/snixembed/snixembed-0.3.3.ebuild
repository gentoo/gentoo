# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vala

DESCRIPTION="Proxy StatusNotifierItems as XEmbedded systemtray-spec icons"
HOMEPAGE="https://git.sr.ht/~steef/snixembed"
SRC_URI="https://git.sr.ht/~steef/snixembed/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="dev-libs/glib:2
	dev-libs/libdbusmenu[gtk3,introspection]
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"
BDEPEND="$(vala_depend)
	virtual/pkgconfig
	doc? ( dev-lang/vala[valadoc] )"

src_prepare() {
	default

	use doc && local VALA_USE_DEPEND="valadoc"
	vala_src_prepare

	sed -e "s:valac :${VALAC} :" \
		-e "s:valadoc :${VALADOC} :" \
		-i makefile || die
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" BINDIR="/usr/bin" MANDIR="/usr/share/man" install
	use doc && HTML_DOCS=( doc/. )
	einstalldocs
}
