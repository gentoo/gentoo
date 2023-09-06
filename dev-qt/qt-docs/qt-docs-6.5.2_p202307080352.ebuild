# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Qt6 documentation, for use with Qt Creator and other tools"
HOMEPAGE="https://doc.qt.io/"

LICENSE="FDL-1.3"
SLOT="6"
KEYWORDS="~amd64"
IUSE="+html +qch"
REQUIRED_USE="|| ( html qch )"

qt6_docs_generate_metadata() {
	local qtver=${PV%%_p*}
	local prefix=${qtver}-0-${PV##*_p}
	local suffix=-documentation.tar.xz
	local baseuri="https://download.qt.io/online/qtsdkrepository/linux_x64/desktop/qt6_${qtver//.}_src_doc_examples/qt.qt6.${qtver//.}.doc"
	SRC_URI=
	S=${WORKDIR}/Docs/Qt-${qtver}

	# format: [+-%]<USE>[/<subdir>][="<module> ..."]
	# '+' = enable, '-' = disable, '%' = always (no IUSE)
	# '-' is suggested for most things not packaged, rest should be enabled
	# (subdir's name is used as default module if nothing is specified)
	local map=(
		# map with (non-split) Qt6 packages rather than per-module
		%base="
			qmake qtconcurrent qtcore qtdbus qtgui qtnetwork
			qtopengl qtplatformintegration qtprintsupport qtsql
			qttestlib qtwidgets qtxml"
		%misc="qtcmake"
		%doc="qtdoc"
		+3d/qt3d
		-activeqt/qtactiveqt="activeqt"
		+charts/qtcharts
		+connectivity/qtbluetooth
		+connectivity/qtnfc
		-datavis/qtdatavis3d
		+declarative="
			qtlabsplatform qtqml qtqmlcore qtqmlmodels
			qtqmltest qtqmlworkerscript qtqmlxmllistmodel
			qtquick qtquickcontrols qtquickdialogs
		"
		-grpc/qtgrpc="qtprotobuf"
		-httpserver/qthttpserver
		+imageformats/qtimageformats
#		-languageserver/qtlanguageserver # no docs
		+location/qtlocation
		-lottie/qtlottie="qtlottieanimation"
		+multimedia/qtmultimedia
		+networkauth/qtnetworkauth
		+positioning/qtpositioning
		+qt5compat/qt5compat="qtcore5compat qtgraphicaleffects5compat"
#		+qt5="qt5" # already installed by qtbase / conflicts
		-quick3dphysics/qtquick3dphysics
		+quick3d/qtquick3d
#		-quickeffectmaker/qtquickeffectmaker # no docs
		-remoteobjects/qtremoteobjects
		+scxml/qtscxml
		+sensors/qtsensors
		-serialbus/qtserialbus
		+serialport/qtserialport
		+shadertools/qtshadertools
		+speech/qtspeech="qttexttospeech"
		+svg="qtsvg"
		+timeline/qtquicktimeline
		+tools="
			qdoc qtassistant qtdesigner qtdistancefieldgenerator
			qthelp qtlinguist qtuitools
		"
		+virtualkeyboard/qtvirtualkeyboard
		+wayland="qtwaylandcompositor"
		+webchannel/qtwebchannel
		+webengine/qtpdf
		+webengine/qtwebengine
		+websockets/qtwebsockets
		-webview/qtwebview
	)

	local docs op use sub uris
	local -A iuse
	for docs in "${map[@]}"; do
		[[ ${docs} =~ ^([%+-])([^/=]+)/?([^=]+)?=?(.+)? ]] # || die in global
		op=${BASH_REMATCH[1]}
		use=${BASH_REMATCH[2]}
		sub=${BASH_REMATCH[3]}
		printf -v uris \
			"${baseuri}${sub:+.${sub}}/${prefix}%s${suffix} " \
			${BASH_REMATCH[4]:-${sub}}

		if [[ ${op} == % ]]; then
			SRC_URI+=" ${uris}"
		else
			iuse[${op#-}${use}]= # avoid duplicates
			SRC_URI+=" ${use}? ( ${uris} )"
		fi
	done
	IUSE+=" ${!iuse[*]}"
}
qt6_docs_generate_metadata

src_install() {
	# QT6_DOCDIR from qt6-build.eclass
	insinto /usr/share/qt6-doc
	use html && doins -r */
	use qch && doins -r *.qch
}
