# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CHECKREQS_DISK_BUILD="6G"
inherit check-reqs

DESCRIPTION="Open Handset Alliance's Android NDK (Native Dev Kit)"
HOMEPAGE="http://developer.android.com/sdk/ndk/"
SRC_URI="https://dl.google.com/android/repository/${PN}-r${PV}-linux-x86_64.zip"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="mirror strip installsources test"

DEPEND="app-arch/p7zip"
RDEPEND=">=dev-util/android-sdk-update-manager-10
	>=sys-devel/make-3.81
	|| (
		sys-libs/ncurses:0/5[tinfo]
		sys-libs/ncurses:5/5[tinfo]
	)"

S="${WORKDIR}/${PN}-r${PV}"

ANDROID_NDK_DIR="opt/${PN}"

QA_PREBUILT="*"
PYTHON_UPDATER_IGNORE="1"

pkg_pretend() {
	check-reqs_pkg_pretend
}

pkg_setup() {
	check-reqs_pkg_setup
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	dodir "/${ANDROID_NDK_DIR}"
	cp -pPR * "${ED}/${ANDROID_NDK_DIR}" || die

	dodir "/${ANDROID_NDK_DIR}/out"
	fowners -R root:android "/${ANDROID_NDK_DIR}"
	fperms 0775 "/${ANDROID_NDK_DIR}/"{,build,platforms,prebuilt}
	fperms 0775 "/${ANDROID_NDK_DIR}/"{python-packages,sources,toolchains}
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
