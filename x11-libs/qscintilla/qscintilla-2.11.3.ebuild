# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils

DESCRIPTION="Qt port of Neil Hodgson's Scintilla C++ editor control"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"

MY_PN=QScintilla
MY_P=${MY_PN}-${PV/_pre/.dev}
if [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.gz"
else
	SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0/15"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 x86"
IUSE="designer doc"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	designer? ( dev-qt/designer:5 )
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default

	# Sub-slot sanity check
	local subslot=${SLOT#*/}
	local version=$(sed -nre 's:.*VERSION\s*=\s*([0-9\.]+):\1:p' "${S}"/Qt4Qt5/qscintilla.pro || die)
	local major=${version%%.*}
	if [[ ${subslot} != ${major} ]]; then
		eerror
		eerror "Ebuild sub-slot (${subslot}) does not match QScintilla major version (${major})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${major}\""
		eerror
		die "sub-slot sanity check failed"
	fi
}

qsci_run_in() {
	pushd "$1" >/dev/null || die
	shift || die
	"$@" || die
	popd >/dev/null || die
}

src_configure() {
	if use designer; then
		# prevent building against system version (bug 466120)
		append-cxxflags -I../Qt4Qt5
		append-ldflags -L../Qt4Qt5
	fi

	qsci_run_in Qt4Qt5 eqmake5
	use designer && qsci_run_in designer-Qt4Qt5 eqmake5
}

src_compile() {
	qsci_run_in Qt4Qt5 emake
	use designer && qsci_run_in designer-Qt4Qt5 emake
}

src_install() {
	qsci_run_in Qt4Qt5 emake INSTALL_ROOT="${D}" install
	use designer && qsci_run_in designer-Qt4Qt5 emake INSTALL_ROOT="${D}" install

	DOCS=( ChangeLog NEWS )
	use doc && HTML_DOCS=( doc/html-Qt4Qt5/. )
	einstalldocs
}
