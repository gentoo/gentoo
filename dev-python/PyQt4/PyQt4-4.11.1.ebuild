# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils multibuild python-r1 qmake-utils toolchain-funcs

DESCRIPTION="Python bindings for the Qt toolkit"
HOMEPAGE="http://www.riverbankcomputing.com/software/pyqt/intro
	https://pypi.python.org/pypi/PyQt4"

if [[ ${PV} == *_pre* ]]; then
	MY_P="PyQt-x11-gpl-snapshot-${PV%_pre*}-${REVISION}"
	SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${MY_P}.tar.gz"
else
	MY_P="PyQt-x11-gpl-${PV}"
	SRC_URI="mirror://sourceforge/pyqt/${MY_P}.tar.gz"
fi

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

IUSE="X dbus debug declarative designer doc examples help kde multimedia opengl phonon script scripttools sql svg webkit xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( X )
	designer? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	phonon? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	webkit? ( X )
"

# Minimal supported version of Qt.
QT_PV="4.8.5:4"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/sip-4.16:=[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}
	X? (
		>=dev-qt/qtgui-${QT_PV}
		>=dev-qt/qttest-${QT_PV}
	)
	dbus? (
		>=dev-python/dbus-python-0.80[${PYTHON_USEDEP}]
		>=dev-qt/qtdbus-${QT_PV}
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	phonon? (
		kde? ( media-libs/phonon[qt4] )
		!kde? ( || ( >=dev-qt/qtphonon-${QT_PV} media-libs/phonon[qt4] ) )
	)
	script? ( >=dev-qt/qtscript-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
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

	# Allow building against KDE's phonon (bug 433944 and others).
	sed -i \
		-e "s:VideoWidget()\":&, extra_include_dirs=[\"${EPREFIX}/usr/include/qt4/QtGui\"]:" \
		-e "s:^\s\+generate_code(\"phonon\":&, extra_include_dirs=[\"${EPREFIX}/usr/include/phonon\"]:" \
		configure.py || die

	if ! use dbus; then
		sed -i -e 's/^\(\s\+\)check_dbus()/\1pass/' configure.py || die
	fi

	python_copy_sources

	preparation() {
		if [[ ${EPYTHON} == python3.* ]]; then
			rm -fr pyuic/uic/port_v2
		else
			rm -fr pyuic/uic/port_v3
		fi
	}
	python_foreach_impl run_in_build_dir preparation
}

pyqt4_use_enable() {
	use $1 && echo --enable=${2:-Qt$(tr 'a-z' 'A-Z' <<< ${1:0:1})${1:1}}
}

src_configure() {
	configuration() {
		local myconf=(
			"${PYTHON}" configure.py
			--confirm-license
			--bindir="${EPREFIX}/usr/bin"
			--destdir="$(python_get_sitedir)"
			--sipdir="${EPREFIX}/usr/share/sip"
			--assume-shared
			--no-timestamp
			--qsci-api
			$(use debug && echo --debug)
			--enable=QtCore
			--enable=QtNetwork
			--enable=QtXml
			$(pyqt4_use_enable X QtGui)
			$(pyqt4_use_enable X QtTest)
			$(pyqt4_use_enable dbus QtDBus)
			$(pyqt4_use_enable declarative)
			$(pyqt4_use_enable designer) $(use designer || echo --no-designer-plugin)
			$(pyqt4_use_enable help)
			$(pyqt4_use_enable multimedia)
			$(pyqt4_use_enable opengl QtOpenGL)
			$(pyqt4_use_enable phonon phonon)
			$(pyqt4_use_enable script)
			$(pyqt4_use_enable scripttools QtScriptTools)
			$(pyqt4_use_enable sql)
			$(pyqt4_use_enable svg)
			$(pyqt4_use_enable webkit QtWebKit)
			$(pyqt4_use_enable xmlpatterns QtXmlPatterns)
			AR="$(tc-getAR) cqs"
			CC="$(tc-getCC)"
			CFLAGS="${CFLAGS}"
			CFLAGS_RELEASE=
			CXX="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CXXFLAGS_RELEASE=
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			LFLAGS="${LDFLAGS}"
			LFLAGS_RELEASE=
			RANLIB=
			STRIP=
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die

		local mod
		for mod in QtCore \
				$(use X && echo QtGui) \
				$(use dbus && echo QtDBus) \
				$(use declarative && echo QtDeclarative) \
				$(use designer && echo QtDesigner) \
				$(use opengl && echo QtOpenGL); do
			# Run eqmake4 inside the qpy subdirectories to respect
			# CC, CXX, CFLAGS, CXXFLAGS, LDFLAGS and avoid stripping.
			pushd qpy/${mod} > /dev/null || return
			eqmake4 $(ls w_qpy*.pro)
			popd > /dev/null || return

			# Fix insecure runpaths.
			sed -i -e "/^LFLAGS\s*=/ s:-Wl,-rpath,${BUILD_DIR}/qpy/${mod}::" \
				${mod}/Makefile || die "failed to fix rpath for ${mod}"
		done

		# Avoid stripping of libpythonplugin.so.
		if use designer; then
			pushd designer > /dev/null || return
			eqmake4 python.pro
			popd > /dev/null || return
		fi
	}
	python_parallel_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		local tmp_root=${D%/}/tmp

		# INSTALL_ROOT is used by designer/Makefile, other Makefiles use DESTDIR.
		emake DESTDIR="${tmp_root}" INSTALL_ROOT="${tmp_root}" install

		python_doexe "${tmp_root}${EPREFIX}"/usr/bin/pyuic4
		rm "${tmp_root}${EPREFIX}"/usr/bin/pyuic4 || die

		multibuild_merge_root "${tmp_root}" "${D}"
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	dodoc NEWS THANKS

	if use doc; then
		dodoc -r doc/html
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
