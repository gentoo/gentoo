# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtdemo/qtdemo-4.8.5-r1.ebuild,v 1.7 2014/12/31 13:11:33 kensington Exp $

EAPI=4

inherit qt4-build

DESCRIPTION="Demonstration module and examples for the Qt toolkit"
SLOT="4"
if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS=""
else
	KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x64-macos"
fi
IUSE="dbus declarative kde multimedia opengl openvg phonon qt3support webkit xmlpatterns"

DEPEND="
	~dev-qt/designer-${PV}[aqua=,debug=]
	~dev-qt/qtcore-${PV}[aqua=,debug=,qt3support?]
	~dev-qt/qtgui-${PV}[aqua=,debug=,qt3support?]
	~dev-qt/qthelp-${PV}[aqua=,debug=]
	~dev-qt/qtscript-${PV}[aqua=,debug=]
	~dev-qt/qtsql-${PV}[aqua=,debug=,qt3support?]
	~dev-qt/qtsvg-${PV}[aqua=,debug=]
	~dev-qt/qttest-${PV}[aqua=,debug=]
	dbus? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=] )
	declarative? ( ~dev-qt/qtdeclarative-${PV}[aqua=,debug=,webkit?] )
	multimedia? ( ~dev-qt/qtmultimedia-${PV}[aqua=,debug=] )
	opengl? ( ~dev-qt/qtopengl-${PV}[aqua=,debug=,qt3support?] )
	openvg? ( ~dev-qt/qtopenvg-${PV}[aqua=,debug=,qt3support?] )
	phonon? (
		kde? ( media-libs/phonon[aqua=,qt4] )
		!kde? ( || ( ~dev-qt/qtphonon-${PV}[aqua=,debug=] media-libs/phonon[aqua=,qt4] ) )
	)
	qt3support? ( ~dev-qt/qt3support-${PV}[aqua=,debug=] )
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=] )
	xmlpatterns? ( ~dev-qt/qtxmlpatterns-${PV}[aqua=,debug=] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.6-plugandpaint.patch"
)

pkg_setup() {
	QT4_TARGET_DIRECTORIES="
		demos
		examples"
	QT4_EXTRACT_DIRECTORIES="${QT4_TARGET_DIRECTORIES}
		doc/src/images
		include
		src
		tools"

	qt4-build_pkg_setup
}

src_prepare() {
	qt4-build_src_prepare

	# Array mapping USE flags to subdirs
	local flags_subdirs_map=(
		'dbus'
		'declarative:declarative'
		'multimedia:spectrum'
		'opengl:boxes|glhypnotizer'
		'openvg'
		'phonon:mediaplayer'
		'webkit:browser'
		'xmlpatterns'
	)

	# Disable unwanted examples/demos
	for flag in "${flags_subdirs_map[@]}"; do
		if ! use ${flag%:*}; then
			einfo "Disabling ${flag%:*} examples"
			sed -i -e "/SUBDIRS += ${flag%:*}/d" \
				examples/examples.pro || die

			if [[ ${flag} == *:* ]]; then
				einfo "Disabling ${flag%:*} demos"
				sed -i -re "/SUBDIRS \+= demos_(${flag#*:})/d" \
					demos/demos.pro || die
			fi
		fi
	done

	if ! use qt3support; then
		einfo "Disabling qt3support examples"
		sed -i -e '/QT_CONFIG, qt3support/d' \
			examples/graphicsview/graphicsview.pro || die
	fi
}

src_configure() {
	myconf+="
		$(qt_use dbus)
		$(qt_use declarative)
		$(qt_use multimedia) -no-audio-backend
		$(qt_use opengl)
		$(qt_use openvg)
		$(qt_use phonon) -no-phonon-backend
		$(qt_use qt3support)
		$(qt_use webkit)
		$(qt_use xmlpatterns)"

	qt4-build_src_configure
}

src_install() {
	insinto "${QTDOCDIR#${EPREFIX}}"/src
	doins -r doc/src/images

	qt4-build_src_install
}
