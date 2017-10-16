# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic multibuild qmake-utils

MY_P=QScintilla_gpl-${PV/_pre/.dev}

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/13"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="designer doc +qt4 qt5"

REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		designer? ( dev-qt/designer:4 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	default

	# Sub-slot sanity check
	local subslot=${SLOT#*/}
	local version=$(sed -nre 's:.*VERSION\s*=\s*([0-9\.]+):\1:p' "${S}"/Qt4Qt5/qscintilla.pro)
	local major=${version%%.*}
	if [[ ${subslot} != ${major} ]]; then
		eerror
		eerror "Ebuild sub-slot (${subslot}) does not match QScintilla major version (${major})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${major}\""
		eerror
		die "sub-slot sanity check failed"
	fi

	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
	multibuild_copy_sources
}

qsci_run_in() {
	pushd "$1" >/dev/null || die
	shift || die
	"$@" || die
	popd >/dev/null || die
}

src_configure() {
	use qt4 && append-cxxflags -std=gnu++0x

	if use designer; then
		# prevent building against system version (bug 466120)
		append-cxxflags -I../Qt4Qt5
		append-ldflags -L../Qt4Qt5
	fi

	qsci_configure() {
		qsci_run_in Qt4Qt5 eqmake${MULTIBUILD_VARIANT#qt}
		use designer && qsci_run_in designer-Qt4Qt5 eqmake${MULTIBUILD_VARIANT#qt}
	}
	multibuild_foreach_variant run_in_build_dir qsci_configure
}

src_compile() {
	qsci_compile() {
		qsci_run_in Qt4Qt5 emake
		use designer && qsci_run_in designer-Qt4Qt5 emake
	}
	multibuild_foreach_variant run_in_build_dir qsci_compile
}

src_install() {
	qsci_install() {
		qsci_run_in Qt4Qt5 emake INSTALL_ROOT="${D}" install
		use designer && qsci_run_in designer-Qt4Qt5 emake INSTALL_ROOT="${D}" install
	}
	multibuild_foreach_variant run_in_build_dir qsci_install

	DOCS=( ChangeLog NEWS )
	use doc && HTML_DOCS=( doc/html-Qt4Qt5/. )
	einstalldocs
}
