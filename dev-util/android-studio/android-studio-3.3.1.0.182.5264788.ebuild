# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils java-pkg-2 eapi7-ver

RESTRICT="strip"
QA_PREBUILT="opt/${PN}/bin/libbreakgen*.so
	opt/${PN}/bin/fsnotifier*
	opt/${PN}/bin/lldb/*
	opt/${PN}/lib/libpty/linux/x86*/libpty.so
	opt/${PN}/plugins/android/lib/libwebp_jni*.so
	opt/${PN}/plugins/android/resources/perfa/*/libperfa.so
	opt/${PN}/plugins/android/resources/perfd/*/perfd
	opt/${PN}/plugins/android/resources/simpleperf/*/simpleperf"

VER_CMP=( $(ver_rs 1- ' ') )
if [[ ${#VER_CMP[@]} -eq 6 ]]; then
	STUDIO_V=$(ver_cut 1-4)
	BUILD_V=$(ver_cut 5-6)
else
	STUDIO_V=$(ver_cut 1-3)
	BUILD_V=$(ver_cut 4-5)
fi

DESCRIPTION="A new Android development environment based on IntelliJ IDEA"
HOMEPAGE="http://developer.android.com/sdk/installing/studio.html"
SRC_URI="https://dl.google.com/dl/android/studio/ide-zips/${STUDIO_V}/${PN}-ide-${BUILD_V}-linux.zip"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="selinux"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/zip
	dev-java/commons-logging:0
	dev-java/log4j:0"

#	dev-java/guava:18
RDEPEND=">=virtual/jdk-1.7
	selinux? ( sec-policy/selinux-android )
	>=app-arch/bzip2-1.0.6-r4
	dev-java/commons-logging:0
	dev-java/log4j:0
	>=dev-libs/expat-2.1.0-r3
	>=dev-libs/libffi-3.0.13-r1
	>=media-libs/fontconfig-2.10.92
	>=media-libs/freetype-2.5.5
	>=media-libs/libpng-1.2.51
	>=media-libs/mesa-10.2.8
	|| ( gnome-extra/zenity kde-apps/kdialog x11-apps/xmessage x11-libs/libnotify )
	>=sys-libs/ncurses-5.9-r3:5/5[tinfo]
	>=sys-libs/zlib-1.2.8-r1
	>=x11-libs/libX11-1.6.2
	>=x11-libs/libXau-1.0.7-r1
	>=x11-libs/libXdamage-1.1.4-r1
	>=x11-libs/libXdmcp-1.1.1-r1
	>=x11-libs/libXext-1.3.2
	>=x11-libs/libXfixes-5.0.1
	>=x11-libs/libXrender-0.9.8
	>=x11-libs/libXxf86vm-1.1.3
	>=x11-libs/libdrm-2.4.46
	>=x11-libs/libxcb-1.9.1
	>=x11-libs/libxshmfence-1.1"
S=${WORKDIR}/${PN}
PATCHES=( "${FILESDIR}/0001-use-java-home-before-bundled.patch" )

src_prepare() {
	eapply "${PATCHES[@]}"
	eapply_user

	# This is really a bundled jdk not a jre
	rm -rf "${S}/jre" || die "Could not remove bundled jdk"

	# Replace bundled jars with system
	# has problems with newer jdom:0 not updated to jdom:2
	cd "${S}/lib" || die
	local JARS="commons-logging log4j"
	local j
	for j in ${JARS}; do
		rm -v ${j/:*/}*.jar || die
		java-pkg_jar-from ${j}
	done

	cd "${S}" || die

	# bug 629404
	echo "-Djdk.util.zip.ensureTrailingSlash=false" >> bin/studio64.vmoptions || die
	echo "-Djdk.util.zip.ensureTrailingSlash=false" >> bin/studio.vmoptions || die
}

src_compile() {
	:
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r *

	# Replaced bundled jre with system vm/jdk
	# This is really a bundled jdk not a jre
	rm -rf "${ED%/}${dir}/jre" || die
	dosym "../../etc/java-config-2/current-system-vm" "${dir}/jre"

	fperms 755 "${dir}/bin/studio.sh" "${dir}"/bin/fsnotifier{,64}
	fperms -R 755 "${dir}"/bin/lldb/{android,bin}
	chmod 755 "${ED%/}${dir}"/bin/*.py "${ED%/}${dir}"/bin/*.sh || die
	chmod 755 "${ED%/}${dir}"/gradle/gradle-*/bin/gradle || die

	newicon "bin/studio.png" "${PN}.png"
	make_wrapper ${PN} ${dir}/bin/studio.sh
	make_desktop_entry ${PN} "Android Studio" ${PN} "Development;IDE" "StartupWMClass=jetbrains-studio"
}
