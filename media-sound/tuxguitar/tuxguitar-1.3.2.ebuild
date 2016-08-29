# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $id$

EAPI="6"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2 toolchain-funcs flag-o-matic fdo-mime gnome2-utils

MY_P="${P}-src"
DESCRIPTION="TuxGuitar is a multitrack guitar tablature editor and player written in Java-SWT"
HOMEPAGE="http://tuxguitar.herac.com.ar/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="alsa fluidsynth jack lilypond oss pdf timidity tray"

KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/swt:3.7[cairo]
	alsa? ( media-libs/alsa-lib )
	pdf? ( dev-java/itext:5 )
	fluidsynth? ( media-sound/fluidsynth )
	lilypond? ( media-sound/lilypond )"

RDEPEND=">=virtual/jre-1.5
	timidity? ( media-sound/timidity++[alsa?,oss?] )
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-fixed-ant-files.patch )

LIBRARY_LIST=()
PLUGIN_LIST=()

src_prepare() {
	java-pkg-2_src_prepare
	default_src_prepare

	sed -e "s|../TuxGuitar/lib/swt.jar|$(java-pkg_getjar swt-3.7 swt.jar)|" \
		-i TuxGuitar*/build.properties || die "sed TuxGuitar*/build.properties failed"

	if use pdf; then
		sed -e "s|../TuxGuitar/lib/itext.jar|$(java-pkg_getjar itext-5 itext.jar)|" \
		-i TuxGuitar-pdf/build.properties || die "sed TuxGuitar-pdf/build.properties failed"
	fi

	LIBRARY_LIST=( TuxGuitar-lib TuxGuitar-awt-graphics TuxGuitar-editor-utils
		TuxGuitar-gm-utils TuxGuitar
	)

	PLUGIN_LIST=( $(usev alsa) ascii browser-ftp community compat
		converter $(usev fluidsynth) gm-settings gpx gtp gtp-ui image
		$(usev jack) $(usex jack jack-ui "") jsa $(usev lilypond) midi
		musicxml $(usev oss) $(usev pdf) ptb svg tef $(usev tray) tuner
	)
}

src_compile() {
	local build_order=( ${LIBRARY_LIST[@]} ${PLUGIN_LIST[@]/#/TuxGuitar-} )
	local directory

	append-flags -fPIC $(java-pkg_get-jni-cflags)

	for directory in ${build_order[@]}; do
		cd "${S}"/${directory} || die "cd ${directory} failed"
		eant
		if [[ -d jni ]]; then
			CC=$(tc-getCC) emake -C jni
		fi
	done
}

src_install() {
	local tuxguitar_inst_path="/usr/share/${PN}"
	local library
	local plugin

	for library in ${LIBRARY_LIST[@]}; do
		cd "${S}"/${library} || die "cd ${library} failed"
		java-pkg_dojar ${library,,}.jar
		use source && java-pkg_dosrc src/org
	done

	java-pkg_dolauncher ${PN} \
		--main org.herac.tuxguitar.app.TGMainSingleton \
		--java_args "-Xmx512m  -Dtuxguitar.share.path=${tuxguitar_inst_path}/share"

	# Images and Files
	insinto ${tuxguitar_inst_path}
	doins -r share

	java-pkg_sointo ${tuxguitar_inst_path}/lib
	insinto ${tuxguitar_inst_path}/share/plugins
	for plugin in ${PLUGIN_LIST[@]/#/TuxGuitar-}; do
		cd "${S}"/${plugin} || die "cd ${plugin} failed"
		doins ${plugin,,}.jar

		#TuxGuitar has its own classloader. No need to register the plugins.
		if [[ -d jni ]]; then
			java-pkg_doso jni/lib${plugin,,}-jni.so
		fi
	done

	insinto ${tuxguitar_inst_path}/share
	doins -r "${S}"/TuxGuitar-resources/resources/soundfont
	doman "${S}/misc/${PN}.1"
	insinto /usr/share/mime/packages
	doins "${S}/misc/${PN}.xml"
	doicon "${S}/misc/${PN}.xpm"
	domenu "${S}/misc/${PN}.desktop"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	if use fluidsynth; then
		ewarn "Fluidsynth plugin blocks behavior of JSA plugin."
		ewarn "Enable only one of them in \"Tools > Plugins\""
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
