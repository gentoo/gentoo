# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Qt6 documentation and examples for Qt Creator and other tools"
HOMEPAGE="https://doc.qt.io/"

LICENSE="FDL-1.3"
SLOT="6"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+examples +html +qch"
REQUIRED_USE="|| ( examples html qch )"

BDEPEND="
	examples? ( $(unpacker_src_uri_depends .7z) )
"

qt6_docs_generate_metadata() {
	local qtver=${PV%%_p*}
	local prefix=${qtver}-0-${PV##*_p}
	local doc_suffix=-documentation.tar.xz
	local exa_suffix=-examples-${qtver}.7z
	local baseuri=https://download.qt.io/online/qtsdkrepository/all_os/qt/qt6_${qtver//.}_src_doc_examples/qt.qt6.${qtver//.}
	SRC_URI=
	S=${WORKDIR}

	# Bumping involves diff'ing the unversioned *_src_doc_examples/*/ files
	# list from old version to the new for -documentation and -examples
	# files, then adding/removing entries if anything changed.
	#
	# Format: [+-%]<USE>[</|^><package>[!|:]][="<module> ..."]
	#  -    [+-%]<USE>: enable(+), disable(-), or no IUSE(%)
	#          (should disable if associated package is not in tree)
	#  -    /<package>: qt.qt6.*.examples.<package>/*-<package>-examples*
	#  -    ^<package>: qt.qt6.*.examples/*-<package>-examples.7z
	#  -      <module>: qt.qt6.*.doc.<package>/*-<module>-documentation*
	#          (if <module> is unspecified, defaults to <package>)
	#  - <package>[!:]: only has examples(!) or documentation(:)
	# Note: sub-300 bytes examples archives are empty, can be skipped
	local map=(
		# map with (non-split) Qt6 packages rather than per-module
		%base^qtbase="
			qmake qtcmake qtconcurrent qtcore qtdbus
			qtgui qtnetwork qtopengl qtplatformintegration
			qtprintsupport qtsql qttestlib qtwidgets qtxml
		"
		+3d/qt3d
		-activeqt/qtactiveqt="activeqt"
		+charts/qtcharts
		+connectivity/qtbluetooth:
		+connectivity/qtconnectivity!
		+connectivity/qtnfc:
		-datavis/qtdatavis3d
		+declarative^qtdeclarative="
			qtlabsplatform qtqml qtqmlcore qtqmlmodels
			qtqmltest qtqmlworkerscript qtqmlxmllistmodel
			qtquick qtquickcontrols qtquickdialogs
		"
		%doc^qtdoc
		-graphs/qtgraphs
		-grpc/qtgrpc="qtgrpc qtprotobuf"
		+httpserver/qthttpserver
		+imageformats/qtimageformats: # empty examples
#		+languageserver/qtlanguageserver # docs and examples are empty
		+location/qtlocation
		-lottie/qtlottie:="qtlottieanimation" # empty examples
		+multimedia/qtmultimedia
		+networkauth/qtnetworkauth
		+positioning/qtpositioning
		+qt5compat/qt5compat="qtcore5compat qtgraphicaleffects5compat"
#		+qt5="qt5" # already installed by qtbase (conflicts)
		-quick3dphysics/qtquick3dphysics
		+quick3d/qtquick3d
		-quickeffectmaker/qtquickeffectmaker
		-remoteobjects/qtremoteobjects
		+scxml/qtscxml
		+sensors/qtsensors
		+serialbus/qtserialbus
		+serialport/qtserialport
		+shadertools/qtshadertools: # empty examples
		+speech/qtspeech="qttexttospeech"
		+svg^qtsvg
		+timeline/qtquicktimeline:
		+tools^qttools="
			qdoc qtassistant qtdesigner qtdistancefieldgenerator
			qthelp qtlinguist qtuitools
		"
		+virtualkeyboard/qtvirtualkeyboard
		+wayland^qtwayland="qtwaylandcompositor"
		+webchannel/qtwebchannel
		+webengine/qtpdf:
		+webengine/qtwebengine
		+websockets/qtwebsockets
		+webview/qtwebview
	)

	local entry operator use subdir package exception modules uris
	local -A iuse
	for entry in "${map[@]}"; do
		[[ ${entry} =~ ^([%+-])([^/^!:=]+)([/^])?([^!:=]+)?([!:])?=?(.+)? ]] # || die
		operator=${BASH_REMATCH[1]#-}
		use=${BASH_REMATCH[2]}
		subdir=${BASH_REMATCH[3]}
		package=${BASH_REMATCH[4]}
		exception=${BASH_REMATCH[5]}
		modules=${BASH_REMATCH[6]:-${package}}

		[[ ${subdir} == / ]] && subdir=.${package} || subdir=

		[[ ${exception} == ! ]] ||
			printf -v uris "${baseuri}.doc${subdir}/${prefix}%s${doc_suffix} " \
				${modules}
		[[ ${exception} == : ]] ||
			uris+=" examples? ( ${baseuri}.examples${subdir}/${prefix}${package}${exa_suffix} )"

		if [[ ${operator} == % ]]; then
			SRC_URI+=" ${uris}"
		else
			iuse[${operator}${use}]= # avoid duplicates
			SRC_URI+=" ${use}? ( ${uris} )"
		fi
	done
	IUSE+=" ${!iuse[*]}"
}
qt6_docs_generate_metadata

src_install() {
	insinto /usr/share/qt6-doc # QT6_DOCDIR
	use qch && doins -r Docs/*/*.qch

	if use html; then
		doins -r Docs/*/*/

		# needed not to let Qt Creator believe that these examples exist
		use examples ||
			find "${ED}" -type f -name examples-manifest.xml -delete || die
	elif use examples; then
		# still need docs tarballs even with USE="-html -qch"
		for dir in Docs/*/*/; do
			if [[ -e ${dir}/examples-manifest.xml ]]; then
				insinto /usr/share/qt6-doc/"${dir#*/*/}"
				doins ${dir}/examples-manifest.xml
			fi
		done
	fi

	insinto /usr/share/qt6/examples # QT6_EXAMPLESDIR
	use examples && doins -r Examples/*/*/
}
