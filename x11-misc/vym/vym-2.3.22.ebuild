# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils

DESCRIPTION="View Your Mind, a mindmap tool"
HOMEPAGE="http://www.insilmaril.de/vym/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

VYM_LINGUAS=( cs_CZ de_DE es fr ia it pt_BR ru sv zh_CN zh_TW )
IUSE+=" ${VYM_LINGUAS[@]/#/linguas_}"

DEPEND="
	dev-qt/qtgui:4[qt3support]
	dev-qt/qtsvg:4
	dbus? ( dev-qt/qtdbus:4 )
"
RDEPEND="
	${DEPEND}
	app-arch/zip
"

DOCS=( README.txt doc/vym.pdf )

src_prepare() {
	epatch "${FILESDIR}"/${P}-arrowobj.patch

	local lingua
	for lingua in ${VYM_LINGUAS[@]}; do
		if ! use linguas_${lingua}; then
			sed -i -e "/lang\/vym_${lingua}.ts/d" CMakeLists.txt || die
			rm -r lang/vym_${lingua}.ts || die
		fi
	done
	sed -i \
		-e '/lang\/vym_en.ts/d' \
		CMakeLists.txt || die
	rm -r lang/vym_en.ts || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use !dbus NO_DBUS)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	doman doc/vym.1.gz
	if use linguas_es ; then
		dodoc doc/vym_es.pdf
	elif use linguas_fr ; then
		dodoc doc/vym_fr.pdf
	fi
	make_desktop_entry vym vym /usr/share/vym/icons/vym.png Education
}
