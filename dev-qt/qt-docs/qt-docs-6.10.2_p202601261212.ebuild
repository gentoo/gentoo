# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Qt6 documentation and examples for Qt Creator and other tools"
HOMEPAGE="https://doc.qt.io/"

LICENSE="FDL-1.3"
SLOT="6"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="+examples +html +qch"
REQUIRED_USE="|| ( examples html qch )"

# passing .7z to avoid looping through the massive list of archives for nothing
BDEPEND="
	examples? ( $(unpacker_src_uri_depends .7z) )
"

qt6_docs_generate_metadata() {
	local qtver=${PV%%_p*}
	local prefix=${qtver}-0-${PV##*_p}
	local doc_suffix=-documentation.tar.xz
	local exa_suffix=-examples-${qtver}.7z
	local baseuri=https://download.qt.io/online/qtsdkrepository/all_os/qt/qt6_${qtver//.}_unix_line_endings_src/qt.qt6.${qtver//.}
	SRC_URI=
	S=${WORKDIR}

	# Bumping involves diff'ing the unversioned *_src/*/ files list from
	# old version to the new for -documentation and -examples files,
	# then adding/removing entries if anything changed.
	#
	# Format: [+-%]<USE>[</|^><package>[!|:]][="<module> ..."]
	#  -    [+-%]<USE>: enable(+), disable(-), or no IUSE(%)
	#          (should disable if associated package is not in tree)
	#  -    /<package>: qt.qt6.*.examples.<package>/*-<package>-examples*
	#  -    ^<package>: qt.qt6.*.examples/*-<package>-examples.7z
	#  -      <module>: qt.qt6.*.doc.<package>/*-<module>-documentation*
	#          (if <module> is unspecified, defaults to <package>)
	#  - <package>[!:]: only has examples(!) or documentation(:)
	#
	# To future maintainers: if this feels too complex, could either
	# replace by generating the ebuild with a new less-compact script
	# or go for the simplest alternative by redistributing 1-2 big
	# tarballs with everything.
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
		+graphs/qtgraphs
		-grpc/qtgrpc="qtgrpc qtprotobuf"
		+httpserver/qthttpserver
		+imageformats/qtimageformats:
		+location/qtlocation
		-lottie/qtlottie="qtlottieanimation"
		+multimedia/qtmultimedia
		+multimedia/qtmultimedia:="qtspatialaudio"
		+networkauth/qtnetworkauth
		+positioning/qtpositioning
		+qt5compat/qt5compat="qtcore5compat qtgraphicaleffects5compat"
#		+qt5="qt5" # already installed by qtbase (conflicts)
		-quick3dphysics/qtquick3dphysics
		+quick3d/qtquick3d
		-quickeffectmaker/qtquickeffectmaker
		+remoteobjects/qtremoteobjects
		+scxml/qtscxml
		+scxml/qtscxml:="qtstatemachine"
		+sensors/qtsensors
		+serialbus/qtserialbus
		+serialport/qtserialport
		+shadertools/qtshadertools:
		+speech/qtspeech="qttexttospeech"
		+svg^qtsvg
		+timeline/qtquicktimeline:
		+tools^qttools="
			qdoc qtassistant qtdesigner qtdistancefieldgenerator
			qthelp qtlinguist qtuitools
		"
		+virtualkeyboard/qtvirtualkeyboard
		+wayland/qtwaylandcompositor
		+webchannel/qtwebchannel
		# webengine archives for docs/examples missing since 6.8.0...?
		#+webengine/qtpdf:
		#+webengine/qtwebengine
		+websockets/qtwebsockets
		+webview/qtwebview
	)

	local entry operator use subdir package exception modules uris
	local -A iuse
	for entry in "${map[@]}"; do
		[[ ${entry} =~ ^([%+-])([^/^!:=]+)([/^])?([^!:=]+)?([!:])?=?(.+)? ]] ||
			die "syntax error in '${entry}'" # global scope, must never fail

		operator=${BASH_REMATCH[1]#-}
		use=${BASH_REMATCH[2]}
		subdir=${BASH_REMATCH[3]}
		package=${BASH_REMATCH[4]}
		exception=${BASH_REMATCH[5]}
		modules=${BASH_REMATCH[6]:-${package}}

		[[ ${subdir} == / ]] && subdir=.${package} || subdir=

		# special rule due to inconsistent examples path since qt 6.8.0
		[[ ${package} == qtwaylandcompositor ]] && package=qtwayland

		[[ ${exception} != ! ]] &&
			printf -v uris "${baseuri}.doc${subdir}/${prefix}%s${doc_suffix} " \
				${modules}
		[[ ${exception} != : ]] &&
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

src_unpack() {
	local a docs=() examples=()
	for a in ${A}; do
		case ${a} in
			*documentation*) docs+=("${a}");;
			*examples*) examples+=("${a}");;
			*) die "unrecognized archive '${a}'";;
		esac
	done

	mkdir docs || die
	pushd docs >/dev/null || die
	unpack "${docs[@]}"
	popd >/dev/null || die

	if use examples; then
		mkdir examples || die
		pushd examples >/dev/null || die
		unpacker "${examples[@]}" # .7z
		popd >/dev/null || die
	fi
}

src_install() {
	insinto /usr/share/qt6-doc # QT6_DOCDIR
	use qch && doins -r docs/*.qch

	if use html; then
		doins -r docs/*/ # trailing '/' skips .qch files

		# needed not to let Qt Creator believe that these examples exist
		use examples ||
			find "${ED}" -type f -name examples-manifest.xml -delete || die
	elif use examples; then
		# still need docs tarballs even with USE="-html -qch"
		local dir
		for dir in docs/*/; do
			if [[ -e ${dir}/examples-manifest.xml ]]; then
				insinto /usr/share/qt6-doc/"${dir#*/*/}"
				doins ${dir}/examples-manifest.xml
			fi
		done
	fi

	insinto /usr/share/qt6/examples # QT6_EXAMPLESDIR
	use examples && doins -r examples/*/
}
