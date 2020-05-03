# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver java-vm-2

abi_uri() {
	echo "${2-$1}? (
			https://github.com/AdoptOpenJDK/openjdk${SLOT}-binaries/releases/download/jdk${MY_PV}/OpenJDK8U-jdk_${1}_linux_hotspot_${MY_PV/-/}.tar.gz
		)"
}

MY_PV=$(ver_rs 1 'u' 2 '-' ${PV//p/b})
SLOT="$(ver_cut 1)"

DESCRIPTION="Prebuilt Java JDK binaries provided by AdoptOpenJDK"
HOMEPAGE="https://adoptopenjdk.net"
SRC_URI="
	$(abi_uri aarch64 arm64)
	$(abi_uri arm)
	$(abi_uri ppc64le ppc64)
	$(abi_uri x64 amd64)
"

LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="~amd64 ~arm arm64 ~ppc64"

IUSE="alsa cups examples headless-awt nsplugin selinux source webstart"

RDEPEND="
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>=sys-apps/baselayout-java-0.1.0-r1
	>=sys-libs/glibc-2.2.5:*
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	selinux? ( sec-policy/selinux-java )
	!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
	)"

PDEPEND="webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )"

RESTRICT="preserve-libs strip"
QA_PREBUILT="*"

S="${WORKDIR}/jdk${MY_PV}"

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED%/}/${dest#/}"

	rm ASSEMBLY_EXCEPTION LICENSE THIRD_PARTY_README || die

	# this does not exist on arm64 hence -f
	rm -fv jre/lib/*/libfreetype.so* || die

	if ! use alsa ; then
		rm -v jre/lib/*/libjsoundalsa.so* || die
	fi

	if ! use examples ; then
		rm -vr sample || die
	fi

	if use headless-awt ; then
		rm -fvr {,jre/}lib/*/lib*{[jx]awt,splashscreen}* \
			{,jre/}bin/policytool bin/appletviewer || die
	fi

	if ! use source ; then
		rm -v src.zip || die
	fi

	rm -v jre/lib/security/cacerts || die
	dosym ../../../../../etc/ssl/certs/java/cacerts \
		"${dest}"/jre/lib/security/cacerts

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}
