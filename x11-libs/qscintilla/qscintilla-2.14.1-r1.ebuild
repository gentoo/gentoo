# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=QScintilla
MY_P=${MY_PN}_src-${PV/_pre/.dev}
inherit flag-o-matic multibuild qmake-utils

DESCRIPTION="Qt port of Neil Hodgson's Scintilla C++ editor control"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${MY_PN}/${PV}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0/15"
KEYWORDS="amd64 arm arm64 ppc ~ppc64 ~riscv x86"
IUSE="designer doc qt5 +qt6"

REQUIRED_USE="|| ( qt5 qt6 )"

# no tests
RESTRICT="test"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		designer? ( dev-qt/qttools:6[designer] )
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_unpack() {
	default

	# Sub-slot sanity check
	local subslot=${SLOT#*/}
	local version=$(sed -nre 's:.*VERSION\s*=\s*([0-9\.]+):\1:p' "${S}"/src/qscintilla.pro || die)
	local major=${version%%.*}
	if [[ ${subslot} != ${major} ]]; then
		eerror
		eerror "Ebuild sub-slot (${subslot}) does not match QScintilla major version (${major})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${major}\""
		eerror
		die "sub-slot sanity check failed"
	fi

	multibuild_copy_sources
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
	my_src_configure() {
		case ${MULTIBUILD_VARIANT} in
			qt5)
				qsci_run_in "${BUILD_DIR}"/src eqmake5;
				use designer && qsci_run_in "${BUILD_DIR}"/designer eqmake5;;
			qt6)
				qsci_run_in "${BUILD_DIR}"/src eqmake6;
				use designer && qsci_run_in "${BUILD_DIR}"/designer eqmake6;;
		esac
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	my_src_compile() {
		qsci_run_in "${BUILD_DIR}"/src emake
		use designer && qsci_run_in "${BUILD_DIR}"/designer emake
	}

	multibuild_foreach_variant my_src_compile
}

src_install() {
	my_src_install() {
		qsci_run_in "${BUILD_DIR}"/src emake INSTALL_ROOT="${D}" install
		use designer && qsci_run_in "${BUILD_DIR}"/designer emake INSTALL_ROOT="${D}" install
	}

	multibuild_foreach_variant my_src_install

	use doc && local HTML_DOCS=( doc/html/. )
	einstalldocs
}
