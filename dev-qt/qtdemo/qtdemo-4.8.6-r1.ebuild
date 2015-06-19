# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-qt/qtdemo/qtdemo-4.8.6-r1.ebuild,v 1.8 2015/05/30 11:07:30 maekke Exp $

EAPI=5

inherit qt4-build-multilib

DESCRIPTION="Demonstration module and examples for the Qt toolkit"

if [[ ${QT4_BUILD_TYPE} == live ]]; then
	KEYWORDS="arm ppc ppc64"
else
	KEYWORDS="amd64 arm ppc ppc64 x86 ~x64-macos"
fi

IUSE="dbus declarative kde multimedia opengl openvg phonon webkit xmlpatterns"

DEPEND="
	~dev-qt/designer-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qthelp-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtscript-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qtsvg-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	~dev-qt/qttest-${PV}[aqua=,debug=,${MULTILIB_USEDEP}]
	dbus? ( ~dev-qt/qtdbus-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	declarative? ( ~dev-qt/qtdeclarative-${PV}[aqua=,debug=,webkit?,${MULTILIB_USEDEP}] )
	multimedia? ( ~dev-qt/qtmultimedia-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	opengl? ( ~dev-qt/qtopengl-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	openvg? ( ~dev-qt/qtopenvg-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	phonon? (
		kde? ( media-libs/phonon[aqua=,qt4] )
		!kde? ( || ( ~dev-qt/qtphonon-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] media-libs/phonon[aqua=,qt4] ) )
	)
	webkit? ( ~dev-qt/qtwebkit-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
	xmlpatterns? ( ~dev-qt/qtxmlpatterns-${PV}[aqua=,debug=,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.6-plugandpaint.patch"
)

QT4_TARGET_DIRECTORIES="
	demos
	examples"

src_prepare() {
	qt4-build-multilib_src_prepare

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

	# Remove bogus dependency on qt3support (bug 510042)
	sed -i -e 's/contains(QT_CONFIG, qt3support)://' \
		examples/graphicsview/graphicsview.pro || die
}

multilib_src_configure() {
	local myconf=(
		$(qt_use dbus)
		$(qt_use declarative)
		$(qt_use multimedia) -no-audio-backend
		$(qt_use opengl)
		$(qt_use openvg)
		$(qt_native_use phonon) -no-phonon-backend
		$(qt_use webkit)
		$(qt_use xmlpatterns)
	)
	qt4_multilib_src_configure
}
