# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user udev

MY_P="android-sdk_r${PV}-linux"

DESCRIPTION="Open Handset Alliance's Android SDK"
HOMEPAGE="http://developer.android.com"
SRC_URI="http://dl.google.com/android/${MY_P}.tgz"
IUSE=""
RESTRICT="mirror"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/tar
		app-arch/gzip"
RDEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.6.5
	|| ( dev-java/swt:3.7[cairo] dev-java/swt:3.6[cairo] )
	sys-libs/zlib[abi_x86_32(-)]
"

ANDROID_SDK_DIR="/opt/${PN}"
QA_FLAGS_IGNORED_x86="
	${ANDROID_SDK_DIR/\/}/tools/emulator
	${ANDROID_SDK_DIR/\/}/tools/adb
	${ANDROID_SDK_DIR/\/}/tools/mksdcard
	${ANDROID_SDK_DIR/\/}/tools/sqlite3
	${ANDROID_SDK_DIR/\/}/tools/hprof-conv
	${ANDROID_SDK_DIR/\/}/tools/zipalign
	${ANDROID_SDK_DIR/\/}/tools/dmtracedump
"
QA_FLAGS_IGNORED_amd64="${QA_FLAGS_IGNORED_x86}"

QA_PREBUILT="${ANDROID_SDK_DIR/\/}/tools/*"

S="${WORKDIR}/android-sdk-linux"

pkg_setup() {
	enewgroup android
}

src_prepare(){
	rm -rf tools/lib/x86*
}

src_install(){
	dodoc tools/NOTICE.txt "SDK Readme.txt"
	rm -f tools/NOTICE.txt "SDK Readme.txt"

	dodir "${ANDROID_SDK_DIR}/tools"
	cp -pPR tools/* "${ED}${ANDROID_SDK_DIR}/tools" || die "failed to install tools"

	# Maybe this is needed for the tools directory too.
	dodir "${ANDROID_SDK_DIR}"/{add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp}

	fowners root:android "${ANDROID_SDK_DIR}"/{.,add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp,tools}
	fperms 0775 "${ANDROID_SDK_DIR}"/{.,add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp,tools}

	echo "PATH=\"${EPREFIX}${ANDROID_SDK_DIR}/tools:${EPREFIX}${ANDROID_SDK_DIR}/platform-tools\"" > "${T}/80${PN}" || die

	SWT_PATH=
	SWT_VERSIONS="3.7 3.6"
	for version in $SWT_VERSIONS; do
		# redirecting stderr to /dev/null
		# not sure if this is best, but avoids misleading error messages
		SWT_PATH="`dirname \`java-config -p swt-\$version 2>/dev/null\` 2>/dev/null`"
		if [ $SWT_PATH ]; then
			einfo "SWT_PATH=$SWT_PATH selecting version $version of SWT."
			break
		fi
	done

	echo "ANDROID_SWT=\"${SWT_PATH}\"" >> "${T}/80${PN}" || die
	echo "ANDROID_HOME=\"${EPREFIX}${ANDROID_SDK_DIR}\"" >> "${T}/80${PN}" || die

	doenvd "${T}/80${PN}"

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}${ANDROID_SDK_DIR}\"" > "${T}/80${PN}" || die

	insinto "/etc/revdep-rebuild" && doins "${T}/80${PN}"

	udev_dorules "${FILESDIR}"/80-android.rules || die
	domenu "${FILESDIR}"/android-sdk-update-manager.desktop
}

pkg_postinst() {
	elog "The Android SDK now uses its own manager for the development	environment."
	elog "Run 'android' to download the full SDK, including some of the platform tools."
	elog "You must be in the android group to manage the development environment."
	elog "Just run 'gpasswd -a <USER> android', then have <USER> re-login."
	elog "See http://developer.android.com/sdk/adding-components.html for more"
	elog "information."
	elog "If you have problems downloading the SDK, see http://code.google.com/p/android/issues/detail?id=4406"
	elog "You need to run env-update and source /etc/profile in any open shells"
	elog "if you get an SWT error."
}
