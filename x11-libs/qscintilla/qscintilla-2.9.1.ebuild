# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit flag-o-matic qmake-utils

MY_P=QScintilla-gpl-${PV}

DESCRIPTION="A Qt port of Neil Hodgson's Scintilla C++ editor class"
HOMEPAGE="http://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/12"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="designer doc"

DEPEND="
	>=dev-qt/qtcore-4.8.5:4
	>=dev-qt/qtgui-4.8.5:4
	designer? ( >=dev-qt/designer-4.8.5:4 )
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

src_configure() {
	pushd Qt4Qt5 > /dev/null
	eqmake4
	popd > /dev/null

	if use designer; then
		# prevent building against system version (bug 466120)
		append-cxxflags -I../Qt4Qt5
		append-ldflags -L../Qt4Qt5

		pushd designer-Qt4Qt5 > /dev/null
		eqmake4
		popd > /dev/null
	fi
}

src_compile() {
	pushd Qt4Qt5 > /dev/null
	emake
	popd > /dev/null

	if use designer; then
		pushd designer-Qt4Qt5 > /dev/null
		emake
		popd > /dev/null
	fi
}

src_install() {
	pushd Qt4Qt5 > /dev/null
	emake INSTALL_ROOT="${D}" install
	popd > /dev/null

	if use designer; then
		pushd designer-Qt4Qt5 > /dev/null
		emake INSTALL_ROOT="${D}" install
		popd > /dev/null
	fi

	dodoc NEWS

	if use doc; then
		docinto html
		dodoc -r doc/html-Qt4Qt5/*
	fi
}
