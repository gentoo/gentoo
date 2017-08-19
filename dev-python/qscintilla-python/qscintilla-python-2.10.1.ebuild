# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit multibuild python-r1 qmake-utils

MY_P=QScintilla_gpl-${PV/_pre/.dev}

DESCRIPTION="Python bindings for Qscintilla"
HOMEPAGE="https://www.riverbankcomputing.com/software/qscintilla/intro"
SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug +qt4 qt5"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	|| ( qt4 qt5 )
"

DEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.19:=[${PYTHON_USEDEP}]
	~x11-libs/qscintilla-${PV}:=[qt4?,qt5?]
	qt4? (
		>=dev-python/PyQt4-4.11.3[X,${PYTHON_USEDEP}]
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	qt5? (
		dev-python/PyQt5[gui,printsupport,widgets,${PYTHON_USEDEP}]
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/Python

src_prepare() {
	default

	# Fix out-of-source build
	sed -i -e 's|sip/qscimod[45]\.sip|../Python/&|g' "${S}"/configure.py || die

	MULTIBUILD_VARIANTS=( $(usev qt4) $(usev qt5) )
}

src_configure() {
	configuration() {
		local my_qt_ver=4
		if [[ ${MULTIBUILD_ID} == *qt5* ]]; then
			my_qt_ver=5
		fi

		local myconf=(
			"${PYTHON}"
			"${S}"/configure.py
			--qmake="$(qt${my_qt_ver}_get_bindir)"/qmake
			--sip-incdir="$(python_get_includedir)"
			--pyqt=PyQt${my_qt_ver}
			$(usex debug '--debug --trace' '')
			--verbose
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		# Run eqmake to respect toolchain, build flags, and prevent stripping
		eqmake${my_qt_ver} -recursive
	}
	multibuild_foreach_variant python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	multibuild_foreach_variant python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake INSTALL_ROOT="${D}" install
		python_optimize
	}
	multibuild_foreach_variant python_foreach_impl run_in_build_dir installation
}
