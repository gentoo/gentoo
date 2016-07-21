# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic qmake-utils

MY_P=QScintilla_gpl-${PV}

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/12"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="designer doc"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	designer? ( dev-qt/designer:4 )
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
}

qsci_run_in() {
	pushd "$1" >/dev/null || die
	shift || die
	"$@" || die
	popd >/dev/null || die
}

src_configure() {
	qsci_run_in Qt4Qt5 eqmake4

	if use designer; then
		# prevent building against system version (bug 466120)
		append-cxxflags -I../Qt4Qt5
		append-ldflags -L../Qt4Qt5

		qsci_run_in designer-Qt4Qt5 eqmake4
	fi
}

src_compile() {
	qsci_run_in Qt4Qt5 emake

	use designer && qsci_run_in designer-Qt4Qt5 emake
}

src_install() {
	qsci_run_in Qt4Qt5 emake INSTALL_ROOT="${D}" install

	use designer && qsci_run_in designer-Qt4Qt5 emake INSTALL_ROOT="${D}" install

	dodoc ChangeLog NEWS

	if use doc; then
		docinto html
		dodoc -r doc/html-Qt4Qt5/*
	fi
}
