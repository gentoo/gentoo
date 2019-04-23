# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver java-vm-2

abi_uri() {
	echo "${2-$1}? (
			https://github.com/AdoptOpenJDK/openjdk${SLOT}-binaries/releases/download/jdk${MY_PV}/OpenJDK8U-jre_${1}_linux_hotspot_${MY_PV/-/}.tar.gz
		)"
}

MY_PV=$(ver_rs 1 'u' 2 '-' ${PV//p/b})
SLOT="$(ver_cut 1)"

DESCRIPTION="Prebuilt Java JRE binaries provided by AdoptOpenJDK"
HOMEPAGE="https://adoptopenjdk.net"
SRC_URI="
	$(abi_uri x64 amd64)
"

LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="~amd64"

IUSE="alsa cups +gentoo-vm headless-awt nsplugin selinux +webstart"

RDEPEND="
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>net-libs/libnet-1.1
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

PDEPEND="
	webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )"

RESTRICT="preserve-libs splitdebug"
QA_PREBUILT="*"

S="${WORKDIR}/jdk${MY_PV}-jre"

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"

	rm ASSEMBLY_EXCEPTION LICENSE THIRD_PARTY_README || die

	# this does not exist on arm64 hence -f
	rm -fv lib/*/libfreetype.so* || die

	if ! use alsa ; then
		rm -v lib/*/libjsoundalsa.so* || die
	fi

	if use headless-awt ; then
		rm -fvr lib/*/lib*{[jx]awt,splashscreen}* \
			bin/policytool || die
	fi

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	use gentoo-vm && java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	if use gentoo-vm ; then
		ewarn "WARNING! You have enabled the gentoo-vm USE flag, making this JRE"
		ewarn "recognised by the system. This will almost certainly break things."
	else
		ewarn "The experimental gentoo-vm USE flag has not been enabled so this JRE"
		ewarn "will not be recognised by the system. For example, simply calling"
		ewarn "\"java\" will launch a different JVM. This is necessary until Gentoo"
		ewarn "fully supports OpenJDK 8. This JRE must therefore be invoked using its"
		ewarn "absolute location under ${EPREFIX}/opt/${P}."
	fi
}
