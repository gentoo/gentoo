# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=(python3_{9..11})

inherit python-r1 udev distutils-r1

DESCRIPTION="Open Handset Alliance's Android SDK"
HOMEPAGE="https://developer.android.com"
SRC_URI="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
RESTRICT="mirror"

LICENSE="android"
SLOT="0"
IUSE="udev"
KEYWORDS="~amd64 ~x86"

DEPEND="
	acct-group/android
	app-arch/gzip
	app-arch/tar
	app-arch/unzip
"

RDEPEND="
	>=dev-java/ant-core-1.6.5
	>=virtual/jdk-1.8:*
	dev-java/swt:3.7[cairo]
	sys-libs/ncurses-compat:5[abi_x86_32(-)]
	sys-libs/zlib[abi_x86_32(-)]
"

ANDROID_SDK_DIR="/opt/${PN}"
QA_FLAGS_IGNORED="
	${ANDROID_SDK_DIR/\//}/tools/mksdcard
	${ANDROID_SDK_DIR/\//}/tools/hprof-conv
"
QA_FLAGS_IGNORED_amd64="${QA_FLAGS_IGNORED}"

QA_PREBUILT="${ANDROID_SDK_DIR/\//}/tools/*"

S="${WORKDIR}/tools"

src_compile() {
	:
}

src_prepare() {
	eapply_user
}

src_install() {
	if use udev; then
		udev_reload
	fi
	dodoc "${S}/NOTICE.txt"

	dodir "${ANDROID_SDK_DIR}/tools"

	cp -pPR "${S}"/* "${ED}${ANDROID_SDK_DIR}/tools" || die "failed to install tools"

	# Maybe this is needed for the tools directory too.
	dodir "${ANDROID_SDK_DIR}"/{add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp}
	fowners -R root:android "${ANDROID_SDK_DIR}"/{.,add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp,tools}
	fperms -R 0775 "${ANDROID_SDK_DIR}"/{.,add-ons,build-tools,docs,extras,platforms,platform-tools,samples,sources,system-images,temp,tools}
	echo "PATH=\"${EPREFIX}${ANDROID_SDK_DIR}/tools:${EPREFIX}${ANDROID_SDK_DIR}/platform-tools\"" > "${T}/80${PN}" || die

	SWT_PATH=
	SWT_VERSIONS="4.27 3.7.2"
	for version in $SWT_VERSIONS; do
		# redirecting stderr to /dev/null
		# not sure if this is best, but avoids misleading error messages
		SWT_PATH="$(dirname $(java-config -p swt-$version 2> /dev/null) 2> /dev/null)"
		if [ $SWT_PATH ]; then
			einfo "SWT_PATH=$SWT_PATH selecting version $version of SWT."
			break
		fi
	done

	echo "ANDROID_SWT=\"${SWT_PATH}\"" >> "${T}/80${PN}" || die "Failed to add the value ANDROID_SWT"
	echo "ANDROID_HOME=\"${EPREFIX}${ANDROID_SDK_DIR}\"" >> "${T}/80${PN}" || die "Failed to add the value ANDROID_HOME"

	doenvd "${T}/80${PN}"

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}${ANDROID_SDK_DIR}\"" > "${T}/80${PN}" || die "Failed to add the value SEARCH_DIRS_MASK"

	insinto "/etc/revdep-rebuild" && doins "${T}/80${PN}"

	udev_dorules "${FILESDIR}"/80-android.rules || die "Failed to run udev_dorules"
}

pkg_postinst() {
	elog "The Android SDK now uses its own manager for the development	environment."
	elog "Run 'android' to download the full SDK, including some of the platform tools."
	elog "You must be in the android group to manage the development environment."
	elog "Just run 'gpasswd -a <USER> android', then have <USER> re-login."
	elog "See https://developer.android.com/sdk/adding-components.html for more"
	elog "information."
	elog "If you have problems downloading the SDK, see https://code.google.com/p/android/issues/detail?id=4406"
	elog "You need to run env-update and source /etc/profile in any open shells"
	elog "if you get an SWT error."
}
