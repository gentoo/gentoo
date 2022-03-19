# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://github.com/teras/Jubler/archive/v7.0.3.tar.gz --slot 0 --keywords "~amd64" --ebuild jubler-7.0.3.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.panayotis.jubler:project:7.0.3"

inherit desktop java-pkg-2 java-pkg-simple toolchain-funcs xdg-utils

DESCRIPTION="Jubler Subtitle Εditor"
HOMEPAGE="https://www.jubler.org/"
SRC_URI="https://github.com/teras/Jubler/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="dev-java/appenh:0"

DEPEND="${CP_DEPEND}
	media-video/ffmpeg:0=
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JUBLER_MODULES=(
	"jubler"
	"appenhancer"
	"aspell"
	"basetextsubs"
	"coretools"
	"mplayer"
	"zemberek"
)

HTML_DOCS=( ChangeLog.html )

PATCHES=( "${FILESDIR}/7.0.3-helpme.patch" )

S="${WORKDIR}/Jubler-${PV}"

src_prepare() {
	java-pkg-2_src_prepare
	default
	# decodeaudio.c:82:24: error: 'AVCODEC_MAX_AUDIO_FRAME_SIZE' undeclared (first use in this function); did you mean 'AV_CODEC_CAP_VARIABLE_FRAME_SIZE'?
	# decodeaudio.c:176:49: error: 'CODEC_ID_NONE' undeclared (first use in this function); did you mean 'AV_CODEC_ID_NONE'?
	# decodeaudio.c:180:38: error: 'AVCodecContext' has no member named 'request_channels'; did you mean 'request_channel_layout'?
	# decodeframe.c:230:31: error: 'PIX_FMT_RGB24' undeclared (first use in this function); did you mean 'AV_PIX_FMT_RGB24'?
	# decodeaudio.c:197:79: error: 'AVIO_WRONLY' undeclared (first use in this function # https://github.com/FFmpeg/FFmpeg/commit/59d96941f0
	# decodeaudio.c:239:26: error: 'AVCodecContext' has no member named 'request_channels'; did you mean 'request_channel_layout'?
	# makecache.c:94:28: error: 'AVCODEC_MAX_AUDIO_FRAME_SIZE' undeclared (first use in this function); did you mean 'AV_CODEC_CAP_VARIABLE_FRAME_SIZE'?
	# decodeaudio.c:339:25: error: 'CODEC_FLAG_GLOBAL_HEADER' undeclared (first use in this function); did you mean 'AV_CODEC_FLAG_GLOBAL_HEADER'
	sed \
		-e 's:AVCODEC_MAX_AUDIO_FRAME_SIZE:AV_CODEC_CAP_VARIABLE_FRAME_SIZE:' \
		-e 's:CODEC_ID_NONE:AV_CODEC_ID_NONE:' \
		-e 's:request_channels:request_channel_layout:' \
		-e 's:PIX_FMT_RGB24:AV_PIX_FMT_RGB24:' \
		-e 's:AVIO_WRONLY:AVIO_FLAG_WRITE:' \
		-e 's:CODEC_FLAG_GLOBAL_HEADER:AV_CODEC_FLAG_GLOBAL_HEADER:' \
		-e 's:CodecID:AVCodecID:' \
		-i resources/ffmpeg/ffdecode/*.c || die
}

src_compile() {
	einfo "Compiling the ffdecode library"
	pushd resources/ffmpeg/ffdecode || die
		local args=(
			JAVA_HOME="$(java-config -g JAVA_HOME)"
			STATIC="no"
			CC="$(tc-getCC)"
			STRIP="$(tc-getSTRIP)"
			LIBNAME="libffdecode.so"
		)
		emake "${args[@]}"
	popd

	jar -cf coretheme.jar -C modules/coretheme/src/main/resources/ . || die
	JAVA_GENTOO_CLASSPATH_EXTRA+=":coretheme.jar"

	mv modules/{core,jubler} || die

	local module
	for module in "${JUBLER_MODULES[@]}"; do
		einfo "Compiling module \"${module}\""
		JAVA_SRC_DIR="modules/${module}/src/main/java"
		JAVA_RESOURCE_DIRS="modules/${module}/src/main/resources"
		JAVA_JAR_FILENAME="${module}.jar"
		if [[ ${module} == jubler ]]; then
			JAVA_MAIN_CLASS="Jubler"
		fi

		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":${module}.jar"
		JAVA_MAIN_CLASS=""
		rm -r target || die
	done

	if use doc; then
		einfo "Compiling javadocs"
		JAVA_SRC_DIR=()
		for module in "${JUBLER_MODULES}"; do
			JAVA_SRC_DIR+=( "modules/${module}/src/main/java" )
		done
		JAVA_JAR_FILENAME="ignoreme.jar"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	java-pkg_doso dist/lib/libffdecode.so
	java-pkg_dojar "coretheme.jar"
	local module
	for module in "${JUBLER_MODULES[@]}"; do
		java-pkg_dojar ${module}.jar
		if use source; then
			java-pkg_dosrc "modules/${module}/src/main/java/*"
		fi
	done

	if use doc; then
		java-pkg_dojavadoc target/api
	fi

	java-pkg_dolauncher "jubler" --main Jubler

	domenu resources/installers/linux/jubler.desktop
	doicon -s 32 resources/installers/linux/jubler32.png
	doicon -s 64 resources/installers/linux/jubler64.png
	doicon -s 128 resources/installers/linux/jubler128.png
	doicon modules/jubler/src/main/resources/icons/splash.jpg
	doicon -s 16 modules/jubler/src/main/resources/icons/crossmobile.png

	# modules/installer/pom.xml#L90-L94
	insinto /usr/share/${PN}/lib/i18n
	doins -r resources/i18n/cache
	insinto /usr/share/${PN}/lib/help
	doins resources/help/{cache/jubler-faq.html,jubler-faq.xml,question.png}
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
