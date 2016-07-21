# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

MY_P="${PN}-r${PV}"

DESCRIPTION="Open Handset Alliance's Android NDK (Native Dev Kit)"
HOMEPAGE="http://developer.android.com/sdk/ndk/"
SRC_URI="https://dl.google.com/android/ndk/${MY_P}-linux-x86.tar.bz2"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror strip installsources test"

DEPEND=""
RDEPEND=">=dev-util/android-sdk-update-manager-10
	>=sys-devel/make-3.81"

S="${WORKDIR}/${MY_P}"

ANDROID_NDK_DIR="opt/${PN}"

ANDROID_TC_ARM_ANDROID_4_4="${ANDROID_NDK_DIR}/toolchains/arm-linux-androideabi-4.4.3/prebuilt/linux-x86"
ANDROID_TC_ARM_ANDROID_4_6="${ANDROID_NDK_DIR}/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86"
ANDROID_TC_MIPS_ANDROID_4_4="${ANDROID_NDK_DIR}/toolchains/mipsel-linux-android-4.4.3/prebuilt/linux-x86"
ANDROID_TC_MIPS_ANDROID_4_6="${ANDROID_NDK_DIR}/toolchains/mipsel-linux-android-4.6/prebuilt/linux-x86"
ANDROID_TC_X86_ANDROID_4_4="${ANDROID_NDK_DIR}/toolchains/x86-4.4.3/prebuilt/linux-x86"
ANDROID_TC_X86_ANDROID_4_6="${ANDROID_NDK_DIR}/toolchains/x86-4.6/prebuilt/linux-x86"

QA_PREBUILT="*"
PYTHON_UPDATER_IGNORE="1"

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir "/${ANDROID_NDK_DIR}"
	cp -pPR * "${ED}/${ANDROID_NDK_DIR}"

	fowners -R root:android "/${ANDROID_NDK_DIR}"
	fperms 0775 "/${ANDROID_NDK_DIR}/"{,build,docs,platforms,samples}
	fperms 0775 "/${ANDROID_NDK_DIR}/"{sources,tests,toolchains}

	dodir "/${ANDROID_NDK_DIR}/out"
	fowners root:android "/${ANDROID_NDK_DIR}/out"
	fperms 3775 "/${ANDROID_NDK_DIR}/out"

	printf '%s' \
		"PATH=\"${EPREFIX}/${ANDROID_NDK_DIR}:" \
		"${EPREFIX}/${ANDROID_TC_ARM_ANDROID_4_4}/bin/:" \
		"${EPREFIX}/${ANDROID_TC_ARM_ANDROID_4_6}/bin/:" \
		"${EPREFIX}/${ANDROID_TC_MIPS_ANDROID_4_4}/bin/:" \
		"${EPREFIX}/${ANDROID_TC_MIPS_ANDROID_4_6}/bin/:" \
		"${EPREFIX}/${ANDROID_TC_X86_ANDROID_4_4}/bin/:" \
		"${EPREFIX}/${ANDROID_TC_X86_ANDROID_4_6}/bin/\"" \
		$'\n' \
		> "${T}/80${PN}"  || die

	doenvd "${T}/80${PN}" || die

	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/${ANDROID_NDK_DIR}\"" \
		> "${T}/80${PN}" || die
	insinto "/etc/revdep-rebuild"
	doins "${T}/80${PN}"
}
