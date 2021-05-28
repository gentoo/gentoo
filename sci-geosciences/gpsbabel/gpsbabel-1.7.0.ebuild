# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_PV="${PV//./_}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="GPS waypoints, tracks and routes converter"
HOMEPAGE="https://www.gpsbabel.org/ https://github.com/gpsbabel/gpsbabel"
if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gpsbabel/gpsbabel.git"
	SRC_URI="doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )"
else
	SRC_URI="
		https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_${MY_PV}.tar.gz
		doc? ( https://www.gpsbabel.org/style3.css -> gpsbabel.org-style3.css )
	"
	KEYWORDS="~amd64 ~ppc ~x86"
	S="${WORKDIR}/gpsbabel-gpsbabel_${MY_PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

DEPEND="
	dev-libs/expat
	dev-qt/qtcore:5
	sci-libs/shapelib:=
	sys-libs/zlib
	virtual/libusb:0
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/docbook-xml-dtd:4.1.2
		dev-lang/perl
		dev-libs/libxslt
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-xmldoc.patch
	"${FILESDIR}"/${PN}-1.7.0-use_system_shapelib.patch
)

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	default

	# ensure bundled libs are not used
	rm -r shapelib zlib || die
	# remove prerequisite zlib/zlib.h
	sed -i -e "s: zlib\/[a-z]*\.h::g" Makefile.in || die
	# remove failing test (fixed by f91d28bf)
	rm testo.d/arc-project.test || die

	use doc && cp "${DISTDIR}/gpsbabel.org-style3.css" "${S}"
}

src_configure() {
	econf \
		$(use_with doc doc "${S}"/doc/manual) \
		QMAKE=$(qt5_get_bindir)/qmake \
		--with-zlib=system
}

src_compile() {
	default

	if use doc; then
		perl xmldoc/makedoc || die
		emake gpsbabel.html
	fi
}

src_install() {
	use doc && HTML_DOCS=( "${S}"/${PN}.html "${S}"/${PN}.org-style3.css )

	default
}
