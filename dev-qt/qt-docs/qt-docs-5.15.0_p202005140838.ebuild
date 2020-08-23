# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PV_FULL=${PV/_p/-0-}
PV_NODOTS=$(ver_rs 1-3 '' ${PV%_p*})
BASE_URI="https://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt5_${PV_NODOTS}_src_doc_examples/qt.qt5.${PV_NODOTS}.doc"

declare -A QT5_DOCS=(
	[3d]="qt3d"
	[assistant]="qtassistant"
	[bluetooth]="qtbluetooth"
	[concurrent]="qtconcurrent"
	[dbus]="qtdbus"
	[declarative]="qtqml qtqmltest qtquick qtquickdialogs qtquickextras"
	[designer]="qtdesigner qtuitools"
	[gamepad]="qtgamepad"
	[graphicaleffects]="qtgraphicaleffects"
	[gui]="qtgui qtplatformheaders"
	[help]="qthelp"
	[imageformats]="qtimageformats"
	[linguist]="qtlinguist"
	[location]="qtlocation"
	[multimedia]="qtmultimedia"
	[network]="qtnetwork"
	[opengl]="qtopengl"
	[positioning]="qtpositioning"
	[printsupport]="qtprintsupport"
	[qdoc]="qdoc"
	[quickcontrols2]="qtquickcontrols"
	[quickcontrols]="qtquickcontrols1"
	[scxml]="qtscxml"
	[sensors]="qtsensors"
	[serialbus]="qtserialbus"
	[serialport]="qtserialport"
	[speech]="qtspeech"
	[sql]="qtsql"
	[svg]="qtsvg"
	[test]="qttestlib"
	[wayland]="qtwaylandcompositor"
	[webchannel]="qtwebchannel"
	[websockets]="qtwebsockets"
	[webview]="qtwebview"
	[widgets]="qtwidgets"
	[x11extras]="qtx11extras"
	[xml]="qtxml"
	[xmlpatterns]="qtxmlpatterns"
)

DESCRIPTION="Qt5 documentation, for use with Qt Creator and other tools"
HOMEPAGE="https://doc.qt.io/"

LICENSE="FDL-1.3"
SLOT="5"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

IUSE="charts datavis +html networkauth +qch script timeline virtualkeyboard webengine"
REQUIRED_USE="|| ( html qch )"

SRC_URI="
	${BASE_URI}/${PV_FULL}qmake-documentation.7z
	${BASE_URI}/${PV_FULL}qtcore-documentation.7z
	${BASE_URI}/${PV_FULL}qtdoc-documentation.7z
	charts? ( ${BASE_URI}.qtcharts/${PV_FULL}qtcharts-documentation.7z )
	datavis? ( ${BASE_URI}.qtdatavis3d/${PV_FULL}qtdatavisualization-documentation.7z )
	networkauth? ( ${BASE_URI}.qtnetworkauth/${PV_FULL}qtnetworkauth-documentation.7z )
	script? ( ${BASE_URI}.qtscript/${PV_FULL}qtscript-documentation.7z
		${BASE_URI}.qtscript/${PV_FULL}qtscripttools-documentation.7z )
	timeline? ( ${BASE_URI}.qtquicktimeline/${PV_FULL}qtquicktimeline-documentation.7z )
	virtualkeyboard? ( ${BASE_URI}.qtvirtualkeyboard/${PV_FULL}qtvirtualkeyboard-documentation.7z )
	webengine? ( ${BASE_URI}.qtwebengine/${PV_FULL}qtwebengine-documentation.7z )
"

for DOCUSE in ${!QT5_DOCS[@]}; do
	IUSE+=" +${DOCUSE}"
	for DOCTAR in ${QT5_DOCS[${DOCUSE}]}; do
		SRC_URI+=" ${DOCUSE}? ( ${BASE_URI}/${PV_FULL}${DOCTAR}-documentation.7z )"
	done
done
unset DOCTAR DOCUSE

BDEPEND="
	app-arch/p7zip
	media-libs/libpng:0
"

S=${WORKDIR}/Docs/Qt-${PV%_p*}

src_prepare() {
	default

	# Fix broken png file, bug 679146
	local png=qtdoc/images/used-in-examples/demos/tweetsearch/content/resources/anonymous.png
	pngfix -q --out=${png/.png/fixed.png} ${png} # see pngfix help for exit codes
	[[ $? -gt 15 ]] && die "Failed to fix ${png}"
	mv -f ${png/.png/fixed.png} ${png} || die
}

src_install() {
	# must be the same as QT5_DOCDIR
	insinto /usr/share/qt5-doc
	use html && doins -r */
	use qch && doins *.qch
}
