# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="Serves ProtonMail to IMAP/SMTP clients"
HOMEPAGE="https://protonmail.com/bridge/"
SRC_URI="https://protonmail.com/download/${P/-bin/}-1.x86_64.rpm"

RESTRICT="bindist mirror"

LICENSE="MIT protonmail-bridge-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	app-crypt/libsecret
	dev-libs/glib:2
	media-sound/pulseaudio
	sys-apps/dbus
	virtual/opengl
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXi
"
BDEPEND="dev-util/patchelf"

S="${WORKDIR}"

QA_PREBUILT="*"

src_prepare() {
	# Bug #660366. To workaround preserving libs, set RUNPATH and rm unused libs
	cd "${S}/usr/lib/protonmail/bridge" || die
	patchelf --set-rpath '$ORIGIN/lib' Desktop-Bridge || die "patchelf failed"
	patchelf --set-rpath '$ORIGIN' lib/libicui18n.so.56 || die "patchelf failed"
	patchelf --set-rpath '$ORIGIN' lib/libicuuc.so.56 || die "patchelf failed"

	rm "lib/libQt53DCore.so.5"
	rm "lib/libQt53DExtras.so.5"
	rm "lib/libQt53DInput.so.5"
	rm "lib/libQt53DLogic.so.5"
	rm "lib/libQt53DQuick.so.5"
	rm "lib/libQt53DQuickExtras.so.5"
	rm "lib/libQt53DQuickInput.so.5"
	rm "lib/libQt53DQuickRender.so.5"
	rm "lib/libQt53DRender.so.5"
	rm "lib/libQt5Concurrent.so.5"
	rm "lib/libQt5Gamepad.so.5"
	rm "lib/libQt5QuickParticles.so.5"
	rm "lib/libqgsttools_p.so.1"
	rm "plugins/audio/libqtaudio_alsa.so"
	rm "plugins/audio/libqtmedia_pulse.so"
	rm "plugins/bearer/libqconnmanbearer.so"
	rm "plugins/bearer/libqgenericbearer.so"
	rm "plugins/bearer/libqnmbearer.so"
	rm "plugins/canbus/libqtpeakcanbus.so"
	rm "plugins/canbus/libqtsocketcanbus.so"
	rm "plugins/canbus/libqttinycanbus.so"
	rm "plugins/designer/libqquickwidget.so"
	rm "plugins/designer/libqwebengineview.so"
	rm "plugins/egldeviceintegrations/libqeglfs-emu-integration.so"
	rm "plugins/egldeviceintegrations/libqeglfs-x11-integration.so"
	rm "plugins/gamepads/libevdevgamepad.so"
	rm "plugins/generic/libqevdevkeyboardplugin.so"
	rm "plugins/generic/libqevdevmouseplugin.so"
	rm "plugins/generic/libqevdevtabletplugin.so"
	rm "plugins/generic/libqevdevtouchplugin.so"
	rm "plugins/generic/libqtuiotouchplugin.so"
	rm "plugins/geometryloaders/libdefaultgeometryloader.so"
	rm "plugins/geometryloaders/libgltfgeometryloader.so"
	rm "plugins/geoservices/libqtgeoservices_esri.so"
	rm "plugins/geoservices/libqtgeoservices_itemsoverlay.so"
	rm "plugins/geoservices/libqtgeoservices_mapbox.so"
	rm "plugins/geoservices/libqtgeoservices_mapboxgl.so"
	rm "plugins/geoservices/libqtgeoservices_nokia.so"
	rm "plugins/geoservices/libqtgeoservices_osm.so"
	rm "plugins/iconengines/libqsvgicon.so"
	rm "plugins/imageformats/libqjp2.so"
	rm "plugins/mediaservice/libgstaudiodecoder.so"
	rm "plugins/mediaservice/libgstcamerabin.so"
	rm "plugins/mediaservice/libgstmediacapture.so"
	rm "plugins/mediaservice/libgstmediaplayer.so"
	rm "plugins/platforminputcontexts/libibusplatforminputcontextplugin.so"
	rm "plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so"
	rm "plugins/platforms/libqeglfs.so"
	rm "plugins/platforms/libqlinuxfb.so"
	rm "plugins/platforms/libqminimal.so"
	rm "plugins/platforms/libqminimalegl.so"
	rm "plugins/platforms/libqoffscreen.so"
	rm "plugins/platforms/libqvnc.so"
	rm "plugins/platformthemes/libqgtk3.so"
	rm "plugins/playlistformats/libqtmultimedia_m3u.so"
	rm "plugins/position/libqtposition_geoclue.so"
	rm "plugins/position/libqtposition_positionpoll.so"
	rm "plugins/printsupport/libcupsprintersupport.so"
	rm "plugins/qmltooling/libqmldbg_debugger.so"
	rm "plugins/qmltooling/libqmldbg_inspector.so"
	rm "plugins/qmltooling/libqmldbg_local.so"
	rm "plugins/qmltooling/libqmldbg_messages.so"
	rm "plugins/qmltooling/libqmldbg_native.so"
	rm "plugins/qmltooling/libqmldbg_nativedebugger.so"
	rm "plugins/qmltooling/libqmldbg_profiler.so"
	rm "plugins/qmltooling/libqmldbg_quickprofiler.so"
	rm "plugins/qmltooling/libqmldbg_server.so"
	rm "plugins/qmltooling/libqmldbg_tcp.so"
	rm "plugins/renderplugins/libscene2d.so"
	rm "plugins/sceneparsers/libassimpsceneimport.so"
	rm "plugins/sceneparsers/libgltfsceneexport.so"
	rm "plugins/sceneparsers/libgltfsceneimport.so"
	rm "plugins/sensorgestures/libqtsensorgestures_plugin.so"
	rm "plugins/sensorgestures/libqtsensorgestures_shakeplugin.so"
	rm "plugins/sensors/libqtsensors_generic.so"
	rm "plugins/sensors/libqtsensors_iio-sensor-proxy.so"
	rm "plugins/sensors/libqtsensors_linuxsys.so"
	rm "plugins/sqldrivers/libqsqlite.so"
	rm "plugins/sqldrivers/libqsqlmysql.so"
	rm "plugins/sqldrivers/libqsqlpsql.so"
	rm "plugins/xcbglintegrations/libqxcb-egl-integration.so"
	rm "qml/Qt/labs/calendar/libqtlabscalendarplugin.so"
	rm "qml/Qt/labs/folderlistmodel/libqmlfolderlistmodelplugin.so"
	rm "qml/Qt/labs/platform/libqtlabsplatformplugin.so"
	rm "qml/Qt/labs/settings/libqmlsettingsplugin.so"
	rm "qml/Qt/labs/sharedimage/libsharedimageplugin.so"
	rm "qml/Qt3D/Animation/libquick3danimationplugin.so"
	rm "qml/Qt3D/Core/libquick3dcoreplugin.so"
	rm "qml/Qt3D/Extras/libquick3dextrasplugin.so"
	rm "qml/Qt3D/Input/libquick3dinputplugin.so"
	rm "qml/Qt3D/Logic/libquick3dlogicplugin.so"
	rm "qml/Qt3D/Render/libquick3drenderplugin.so"
	rm "qml/QtBluetooth/libdeclarative_bluetooth.so"
	rm "qml/QtCanvas3D/libqtcanvas3d.so"
	rm "qml/QtCharts/libqtchartsqml2.so"
	rm "qml/QtDataVisualization/libdatavisualizationqml2.so"
	rm "qml/QtGamepad/libdeclarative_gamepad.so"
	rm "qml/QtLocation/libdeclarative_location.so"
	rm "qml/QtMultimedia/libdeclarative_multimedia.so"
	rm "qml/QtNfc/libdeclarative_nfc.so"
	rm "qml/QtPositioning/libdeclarative_positioning.so"
	rm "qml/QtPurchasing/libdeclarative_purchasing.so"
	rm "qml/QtQml/Models.2/libmodelsplugin.so"
	rm "qml/QtQml/StateMachine/libqtqmlstatemachine.so"
	rm "qml/QtQuick/Controls.2/Material/libqtquickcontrols2materialstyleplugin.so"
	rm "qml/QtQuick/Controls.2/Universal/libqtquickcontrols2universalstyleplugin.so"
	rm "qml/QtQuick/Controls/Styles/Flat/libqtquickextrasflatplugin.so"
	rm "qml/QtQuick/Controls/libqtquickcontrolsplugin.so"
	rm "qml/QtQuick/Dialogs/Private/libdialogsprivateplugin.so"
	rm "qml/QtQuick/Dialogs/libdialogplugin.so"
	rm "qml/QtQuick/Extras/libqtquickextrasplugin.so"
	rm "qml/QtQuick/LocalStorage/libqmllocalstorageplugin.so"
	rm "qml/QtQuick/Particles.2/libparticlesplugin.so"
	rm "qml/QtQuick/PrivateWidgets/libwidgetsplugin.so"
	rm "qml/QtQuick/Scene2D/libqtquickscene2dplugin.so"
	rm "qml/QtQuick/Scene3D/libqtquickscene3dplugin.so"
	rm "qml/QtQuick/VirtualKeyboard/Styles/libqtvirtualkeyboardstylesplugin.so"
	rm "qml/QtQuick/XmlListModel/libqmlxmllistmodelplugin.so"
	rm "qml/QtScxml/libdeclarative_scxml.so"
	rm "qml/QtSensors/libdeclarative_sensors.so"
	rm "qml/QtTest/libqmltestplugin.so"
	rm "qml/QtWebChannel/libdeclarative_webchannel.so"
	rm "qml/QtWebEngine/libqtwebengineplugin.so"
	rm "qml/QtWebSockets/libdeclarative_qmlwebsockets.so"
	rm "qml/QtWebView/libdeclarative_webview.so"

	default
}

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR "${S}"/usr "${D}"/ || die "Failed to copy files"

	dosym "Desktop-Bridge" "/usr/bin/${PN}" || die

	cat <<-EOF > "${T}/50-${PN}" || die
		SEARCH_DIRS_MASK="/usr/lib*/protonmail/bridge"
	EOF
	insinto /etc/revdep-rebuild
	doins "${T}/50-${PN}"
}
