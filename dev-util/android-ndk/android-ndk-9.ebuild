# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/android-ndk/android-ndk-9.ebuild,v 1.1 2013/09/27 15:45:54 cardoe Exp $

EAPI=5

MY_P="${PN}-r${PV}"

DESCRIPTION="Open Handset Alliance's Android NDK (Native Dev Kit)"
HOMEPAGE="http://developer.android.com/sdk/ndk/"
SRC_URI="x86? ( http://dl.google.com/android/ndk/${MY_P}-linux-x86.tar.bz2
	legacy-toolchains? ( http://dl.google.com/android/ndk/${MY_P}-linux-x86-legacy-toolchains.tar.bz2 ) )
	amd64? ( http://dl.google.com/android/ndk/${MY_P}-linux-x86_64.tar.bz2
	legacy-toolchains? ( http://dl.google.com/android/ndk/${MY_P}-linux-x86_64-legacy-toolchains.tar.bz2 ) )"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="legacy-toolchains"
RESTRICT="mirror strip installsources test"

DEPEND=""
RDEPEND=">=dev-util/android-sdk-update-manager-10
	>=sys-devel/make-3.81"

S="${WORKDIR}/${MY_P}"

ANDROID_NDK_DIR="opt/${PN}"

QA_PREBUILT="*"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir "/${ANDROID_NDK_DIR}"
	cp -pPR * "${ED}/${ANDROID_NDK_DIR}" || die

	fowners -R root:android "/${ANDROID_NDK_DIR}"
	fperms 0775 "/${ANDROID_NDK_DIR}/"{,build,docs,platforms,samples}
	fperms 0775 "/${ANDROID_NDK_DIR}/"{sources,tests,toolchains}

	dodir "/${ANDROID_NDK_DIR}/out"
	fowners root:android "/${ANDROID_NDK_DIR}/out"
	fperms 3775 "/${ANDROID_NDK_DIR}/out"

	ANDROID_PREFIX="${EPREFIX}/${ANDROID_NDK_DIR}"
	ANDROID_PATH="${EPREFIX}/${ANDROID_NDK_DIR}"

	for i in toolchains/*/prebuilt/linux-*/bin
	do
		ANDROID_PATH="${ANDROID_PATH}:${ANDROID_PREFIX}/${i}"
	done

	printf '%s' \
		"PATH=\"${ANDROID_PATH}\"" \
		$'\n' \
		> "${T}/80${PN}"  || die

	doenvd "${T}/80${PN}"

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/${ANDROID_NDK_DIR}\"" \
		> "${T}/80${PN}" || die
	insinto "/etc/revdep-rebuild"
	doins "${T}/80${PN}"
}
