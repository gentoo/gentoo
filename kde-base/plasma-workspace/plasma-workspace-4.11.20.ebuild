# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/plasma-workspace/plasma-workspace-4.11.20.ebuild,v 1.2 2015/06/04 18:45:04 kensington Exp $

EAPI=5

DECLARATIVE_REQUIRED="always"
KDE_HANDBOOK="optional"
KMNAME="kde-workspace"
KMMODULE="plasma"
PYTHON_COMPAT=( python2_7 )
OPENGL_REQUIRED="always"
inherit python-single-r1 kde4-meta

DESCRIPTION="Plasma: KDE desktop framework"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug gps json +kdepim nepomuk python qalculate"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

COMMONDEPEND="
	dev-libs/libdbusmenu-qt
	>=dev-qt/qtcore-4.8.4-r3:4
	!kde-misc/ktouchpadenabler
	$(add_kdebase_dep kactivities)
	$(add_kdebase_dep kdelibs 'nepomuk?')
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep ksysguard)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libplasmaclock 'kdepim?')
	$(add_kdebase_dep libplasmagenericshell)
	$(add_kdebase_dep libtaskmanager)
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrender
	gps? ( >=sci-geosciences/gpsd-2.37 )
	json? ( dev-libs/qjson )
	kdepim? ( $(add_kdebase_dep kdepimlibs) )
	nepomuk? (
		dev-libs/soprano
		$(add_kdebase_dep nepomuk-core)
	)
	python? (
		${PYTHON_DEPS}
		>=dev-python/PyQt4-4.4.0[X,${PYTHON_USEDEP}]
		$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}")
	)
	qalculate? ( sci-libs/libqalculate )
"
DEPEND="${COMMONDEPEND}
	dev-libs/boost
	x11-proto/compositeproto
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/renderproto
"
RDEPEND="${COMMONDEPEND}
	$(add_kdeapps_dep plasma-runtime)
"

KMEXTRA="
	appmenu/
	ktouchpadenabler/
	statusnotifierwatcher/
"
KMEXTRACTONLY="
	kcheckpass/
	krunner/dbus/org.freedesktop.ScreenSaver.xml
	krunner/dbus/org.kde.krunner.App.xml
	ksmserver/org.kde.KSMServerInterface.xml
	ksmserver/screenlocker/
	libs/kephal/
	libs/kworkspace/
	libs/taskmanager/
	libs/plasmagenericshell/
	libs/ksysguard/
	libs/kdm/kgreeterplugin.h
	ksysguard/
"

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
	fi
	kde4-meta_pkg_setup
}

src_unpack() {
	if use handbook; then
		KMEXTRA+=" doc/plasma-desktop"
	fi

	kde4-meta_src_unpack
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with gps libgps)
		$(cmake-utils_use_with json QJSON)
		$(cmake-utils_use_with kdepim Akonadi)
		$(cmake-utils_use_with kdepim KdepimLibs)
		$(cmake-utils_use_with nepomuk NepomukCore)
		$(cmake-utils_use_with nepomuk Soprano)
		$(cmake-utils_use_with python PythonLibrary)
		$(cmake-utils_use_with qalculate)
		-DWITH_Xmms=OFF
	)

	kde4-meta_src_configure
}

src_install() {
	kde4-meta_src_install

	if use python; then
		python_optimize "${ED}"
	fi
}
