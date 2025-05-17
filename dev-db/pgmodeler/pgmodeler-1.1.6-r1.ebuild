# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POSTGRES_COMPAT=( {13..17} )
inherit desktop postgres qmake-utils

DESCRIPTION="PostgreSQL Database Modeler"
HOMEPAGE="https://pgmodeler.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${POSTGRES_DEP}
	dev-libs/libxml2:=
	dev-qt/qtbase:6[gui,network,opengl,widgets,X]
	dev-qt/qtsvg:6
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e "/^doc.files/s/LICENSE //" -i pgmodeler.pro || die
}

src_configure() {
	local myqmakeargs=(
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		PREFIX="${EPREFIX}/usr"
		PLUGINSDIR="${EPREFIX}/usr/$(get_libdir)/${PN}/plugins"
		PRIVATEBINDIR="${EPREFIX}/usr/$(get_libdir)/${PN}/bin"
		PRIVATELIBDIR="${EPREFIX}/usr/$(get_libdir)/${PN}"
		NO_UPDATE_CHECK="true"
	)
	eqmake6 "${myqmakeargs[@]}" -r ${PN}.pro
}

src_test() {
	local myqmakeargs=(
		BINDIR="${T}"
		SAMPLESDIR="${S}/assets/samples"
		SCHEMASDIR="${S}/assets"
	)

	pushd "${S}/tests" || die
		# skip tests with graphical interaction
		sed	-e '/^src\/fileselectortest/d' \
			-e '/^src\/linenumberstest/d' \
			-i tests.pro || die
		# skip test with sandbox restriction (/proc/self/mem)
		sed	-e '/^src\/syntaxhighlightertest/d' \
			-i tests.pro || die
		# skip xml tests
		# see https://github.com/pgmodeler/pgmodeler/issues/1971
		sed	-e '/^src\/foreigndatawrappertest/d' \
			-e '/^src\/proceduretest/d' \
			-e '/^src\/servertest/d' \
			-e '/^src\/transformtest/d' \
			-e '/^src\/xmlparsertest/d' \
			-i tests.pro || die

		eqmake6 "${myqmakeargs[@]}" tests.pro
		emake

		# append all shared-libs to LD_LIBRARY_PATH
		local l
		for l in "${S}"/libs/*; do
			[[ -d ${l} ]] && LD_LIBRARY_PATH+=":${l}"
		done
		export LD_LIBRARY_PATH

		local -x QT_QPA_PLATFORM=offscreen

		# run each test individually
		local t
		for t in $(find src -type f -executable); do
			${t} || die "${t} failed"
		done
	popd || die
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	doicon assets/conf/${PN}_logo.png
	make_desktop_entry ${PN} ${PN} ${PN}_logo Development
}
