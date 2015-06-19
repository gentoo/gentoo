# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/massxpert/massxpert-3.4.0.ebuild,v 1.1 2014/01/06 15:24:25 jlec Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Software suite to predict/analyze mass spectrometric data on (bio)polymers"
HOMEPAGE="http://massxpert.org"
SRC_URI="http://download.tuxfamily.org/${PN}/source/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="dev-qt/qtsvg:4[debug?]"
DEPEND="${DEPEND}
	doc? ( virtual/latex-base )"

MASSXPERT_LANGS="fr"

for L in ${MASSXPERT_LANGS}; do
	IUSE="${IUSE} linguas_${L}"
done

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"

	local langs=
	for lingua in ${LINGUAS}; do
		if has ${lingua} ${MASSXPERT_LANGS}; then
			langs="${langs} ${PN}_${lingua}.qm"
		fi
	done

	sed -i -e "s/\(SET (massxpert_TRANSLATIONS \).*/\1${langs})/" \
		gui/CMakeLists.txt || die "setting up translations failed"
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PROGRAM=1
		-DBUILD_DATA=1
	)
	use doc && mycmakeargs+=( -DBUILD_USERMANUAL=1 )

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doicon "gui/images/${PN}-icon-32.xpm"
	dodoc TODO
}
