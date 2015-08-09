# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multibuild multilib python-r1 qmake-utils

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://www.riverbankcomputing.com/software/pyqt/intro
	https://pypi.python.org/pypi/PyQt4"

MY_PN="PyQt-x11-gpl"
if [[ ${PV} == *_pre* ]]; then
	MY_P=${MY_PN}-${PV%_pre*}-snapshot-${REVISION}
	SRC_URI="http://dev.gentoo.org/~pesa/distfiles/${MY_P}.tar.xz"
else
	MY_P=${MY_PN}-${PV}
	SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

IUSE="X dbus debug declarative designer doc examples help kde multimedia
	opengl phonon script scripttools sql svg testlib webkit xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	sql? ( X )
	testlib? ( X )
"

# Minimal supported version of Qt.
QT_PV="4.8.5:4"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.16.6:=[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	X? ( >=dev-qt/qtgui-${QT_PV} )
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		>=dev-qt/qtdbus-${QT_PV}
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	phonon? (
		kde? ( >=media-libs/phonon-4.7[qt4] )
		!kde? ( || ( >=dev-qt/qtphonon-${QT_PV} >=media-libs/phonon-4.7[qt4] ) )
	)
	script? ( >=dev-qt/qtscript-${QT_PV} )
	scripttools? ( >=dev-qt/qtgui-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	testlib? ( >=dev-qt/qttest-${QT_PV} )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	dbus? ( virtual/pkgconfig )
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# Support qreal on arm architecture (bug 322349).
	use arm && epatch "${FILESDIR}/${PN}-4.7.3-qreal_float_support.patch"

	# Allow building against KDE's phonon (bug 525354).
	epatch "${FILESDIR}/${PN}-4.11.2-phonon.patch"
}

pyqt_use_enable() {
	use $1 && echo --enable=${2:-Qt$(tr 'a-z' 'A-Z' <<< ${1:0:1})${1:1}}
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}"
			"${S}"/configure-ng.py
			$(use debug && echo --debug --trace)
			--verbose
			--confirm-license
			--qmake="$(qt4_get_bindir)"/qmake
			--destdir="$(python_get_sitedir)"
			--qsci-api
			--enable=QtCore
			--enable=QtNetwork
			--enable=QtXml
			$(pyqt_use_enable X QtGui)
			$(pyqt_use_enable dbus QtDBus)
			$(usex dbus '' --no-python-dbus)
			$(pyqt_use_enable declarative)
			$(pyqt_use_enable designer)
			$(usex designer '' --no-designer-plugin)
			$(pyqt_use_enable help)
			$(pyqt_use_enable multimedia)
			$(pyqt_use_enable opengl QtOpenGL)
			$(pyqt_use_enable phonon phonon)
			$(pyqt_use_enable script)
			$(pyqt_use_enable scripttools QtScriptTools)
			$(pyqt_use_enable sql)
			$(pyqt_use_enable svg)
			$(pyqt_use_enable testlib QtTest)
			$(pyqt_use_enable webkit QtWebKit)
			$(pyqt_use_enable xmlpatterns QtXmlPatterns)
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		eqmake4 -recursive ${PN}.pro
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		local tmp_root=${D%/}/tmp
		emake INSTALL_ROOT="${tmp_root}" install

		local uic_dir=${tmp_root}$(python_get_sitedir)/${PN}/uic
		if python_is_python3; then
			rm -r "${uic_dir}"/port_v2 || die
		else
			rm -r "${uic_dir}"/port_v3 || die
		fi

		python_doexe "${tmp_root}${EPREFIX}"/usr/bin/pyuic4
		rm "${tmp_root}${EPREFIX}"/usr/bin/pyuic4 || die

		multibuild_merge_root "${tmp_root}" "${D}"
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	dodoc ChangeLog NEWS THANKS

	if use doc; then
		dodoc -r doc/html
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
