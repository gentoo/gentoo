# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop user udev

ANDROID_SDK_DIR="/opt/android-sdk-update-manager"
MY_P="android-sdk_r${PV}-linux"

DESCRIPTION="Open Handset Alliance's Android SDK"
HOMEPAGE="https://developer.android.com"
SRC_URI="https://dl.google.com/android/${MY_P}.tgz"
S="${WORKDIR}/android-sdk-linux"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="acct-group/android"
RDEPEND="
	${DEPEND}
	dev-java/ant-core
	dev-java/swt:3.7[cairo]
	>=virtual/jdk-1.8
	sys-libs/ncurses-compat:5[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
"

QA_PREBUILT="*"

src_prepare() {
	default
	rm -rf tools/lib/x86* || die
}

src_install() {
	dodoc tools/NOTICE.txt "SDK Readme.txt"
	rm -f tools/NOTICE.txt "SDK Readme.txt" || die

	dodir "${ANDROID_SDK_DIR}/tools"
	cp -pPR tools/* "${ED}${ANDROID_SDK_DIR}/tools" || die

	# Maybe this is needed for the tools directory too.
	dodir "${ANDROID_SDK_DIR}"/{add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp}

	fowners -R root:android "${ANDROID_SDK_DIR}"/{.,add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp,tools}
	fperms -R 0775 "${ANDROID_SDK_DIR}"/{.,add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp,tools}

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
	elog "The Android SDK now uses its own manager for the development      environment."
	elog "Run 'android' to download the full SDK, including some of the platform tools."
	elog "You must be in the android group to manage the development environment."
	elog "Just run 'gpasswd -a <USER> android', then have <USER> re-login."
	elog "See https://developer.android.com/sdk/adding-components.html for more"
	elog "information."
	elog "If you have problems downloading the SDK, see https://code.google.com/p/android/issues/detail?id=4406"
	elog "You need to run env-update and source /etc/profile in any open shells"
	elog "if you get an SWT error."
}
