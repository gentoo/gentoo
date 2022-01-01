# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver java-vm-2

abi_uri() {
	local os=linux
	case ${2} in
		*-macos)    os=mac      ;;
		*-solaris)  os=solaris  ;;
	esac
	echo "${2-$1}? (
			https://github.com/AdoptOpenJDK/openjdk${SLOT}-binaries/releases/download/jdk${MY_PV}/OpenJDK8U-jdk_${1}_${os}_hotspot_${3-${MY_PV/-/}}.tar.gz
		)"
}

# they have different tarball names for different arches...
# https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u282-b08/OpenJDK8U-jdk_x64_linux_hotspot_8u282b08.tar.gz
# https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u282-b08/OpenJDK8U-jdk_aarch64_linux_hotspot_jdk8u282-b08.tar.gz

MY_PV=$(ver_rs 1 'u' 2 '-' ${PV//p/b})
SLOT="$(ver_cut 1)"

DESCRIPTION="Prebuilt Java JDK binaries provided by AdoptOpenJDK"
HOMEPAGE="https://adoptopenjdk.net"
SRC_URI="
	$(abi_uri aarch64 arm64)
	$(abi_uri arm)
	$(abi_uri ppc64le ppc64)
	$(abi_uri x64 amd64)
	$(abi_uri x64 x64-macos)
"

LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="amd64 ~arm arm64 ppc64 ~x64-macos"

IUSE="alsa cups examples headless-awt selinux source"

RDEPEND="
	>=sys-apps/baselayout-java-0.1.0-r1
	kernel_linux? (
		media-libs/fontconfig:1.0
		media-libs/freetype:2
		>=sys-libs/glibc-2.2.5:*
		sys-libs/zlib
		alsa? ( media-libs/alsa-lib )
		arm? ( dev-libs/libffi-compat:6 )
		cups? ( net-print/cups )
		selinux? ( sec-policy/selinux-java )
		!headless-awt? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXrender
			x11-libs/libXtst
		)
	)
"

RESTRICT="preserve-libs strip"
QA_PREBUILT="*"

S="${WORKDIR}/jdk${MY_PV}"

src_unpack() {
	default
	# 753575
	if use arm; then
		mv -v "${S}"* "${S}" || die
	elif [[ ${A} == *_mac_* ]] ; then
		mv -v "${S}/Contents/Home/"* "${S}" || die
		rm -Rf "${S}/Contents"  # drop macOS executable
	fi
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED%/}/${dest#/}"

	rm ASSEMBLY_EXCEPTION LICENSE THIRD_PARTY_README || die

	# on macOS if they would exist they would be called .dylib, but most
	# importantly, there are no different providers, so everything
	# that's shipped works.
	if [[ ${A} != *_mac_* ]] ; then
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
