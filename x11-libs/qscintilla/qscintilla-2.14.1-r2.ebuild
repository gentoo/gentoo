# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=QScintilla
MY_P=${MY_PN}_src-${PV/_pre/.dev}
inherit flag-o-matic qmake-utils

DESCRIPTION="Qt port of Neil Hodgson's Scintilla C++ editor control"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0/15"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 ~riscv x86"
IUSE="designer doc"

# no tests
RESTRICT="test"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	designer? ( dev-qt/qttools:6[designer] )
"
DEPEND="${RDEPEND}"

src_unpack() {
	default

	# Sub-slot sanity check
	local subslot=${SLOT#*/}
	local version=$(sed -nre 's:.*VERSION\s*=\s*([0-9\.]+):\1:p' "${S}"/src/qscintilla.pro || die)
	local major=${version%%.*}
	if [[ ${subslot} != ${major} ]]; then
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
		append-cxxflags -I../src
		append-ldflags -L../src
	fi
	qsci_run_in src eqmake6
	use designer && qsci_run_in designer eqmake6
}

src_compile() {
	qsci_run_in src emake
	use designer && qsci_run_in designer emake
}

src_install() {
	qsci_run_in src emake INSTALL_ROOT="${D}" install
	use designer && qsci_run_in designer emake INSTALL_ROOT="${D}" install

	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
