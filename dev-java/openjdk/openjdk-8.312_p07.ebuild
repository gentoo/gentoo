# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs eapi7-ver flag-o-matic java-pkg-2 java-vm-2 multiprocessing pax-utils toolchain-funcs

# we need latest -ga tag from hg, but want to keep build number as well
# as _p component of the gentoo version string.

MY_PV=$(ver_rs 1 'u' 2 '-' ${PV%_p*}-ga)
MY_PN_AARCH64="${PN}-aarch64-shenandoah"
MY_PV_AARCH64="$(ver_rs 1 'u' 2 '-' ${PV/_p/-b})"
MY_P_AARCH64="${MY_PN_AARCH64/#${PN}-}-jdk${MY_PV_AARCH64}"

BASE_URI="https://hg.${PN}.java.net/jdk8u/jdk8u"
AARCH64_URI="https://hg.${PN}.java.net/aarch64-port/jdk8u-shenandoah"

DESCRIPTION="Open source implementation of the Java programming language"
HOMEPAGE="https://openjdk.java.net"
SRC_URI="
	!arm64? (
		${BASE_URI}/archive/jdk${MY_PV}.tar.bz2 -> ${P}.tar.bz2
		${BASE_URI}/corba/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-corba-${PV}.tar.bz2
		${BASE_URI}/hotspot/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-hotspot-${PV}.tar.bz2
		${BASE_URI}/jaxp/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-jaxp-${PV}.tar.bz2
		${BASE_URI}/jaxws/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-jaxws-${PV}.tar.bz2
		${BASE_URI}/jdk/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-jdk-${PV}.tar.bz2
		${BASE_URI}/langtools/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-langtools-${PV}.tar.bz2
		${BASE_URI}/nashorn/archive/jdk${MY_PV}.tar.bz2 -> ${PN}-nashorn-${PV}.tar.bz2
	)
	arm64? (
		${AARCH64_URI}/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-${PV}.tar.bz2
		${AARCH64_URI}/corba/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-corba-${PV}.tar.bz2
		${AARCH64_URI}/hotspot/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-hotspot-${PV}.tar.bz2
		${AARCH64_URI}/jaxp/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-jaxp-${PV}.tar.bz2
		${AARCH64_URI}/jaxws/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-jaxws-${PV}.tar.bz2
		${AARCH64_URI}/jdk/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-jdk-${PV}.tar.bz2
		${AARCH64_URI}/langtools/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-langtools-${PV}.tar.bz2
		${AARCH64_URI}/nashorn/archive/${MY_P_AARCH64}.tar.bz2 -> ${MY_PN_AARCH64}-nashorn-jdk${PV}.tar.bz2
	)
"

LICENSE="GPL-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="alsa debug cups doc examples headless-awt javafx +jbootstrap +pch selinux source"

COMMON_DEPEND="
	media-libs/freetype:2=
	media-libs/giflib:0/7
	sys-libs/zlib
"
# Many libs are required to build, but not to run, make is possible to remove
# by listing conditionally in RDEPEND unconditionally in DEPEND
RDEPEND="
	${COMMON_DEPEND}
	>=sys-apps/baselayout-java-0.1.0-r1
	!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXt
		x11-libs/libXtst
	)
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	selinux? ( sec-policy/selinux-java )
"

DEPEND="
	${COMMON_DEPEND}
	app-arch/zip
	media-libs/alsa-lib
	net-print/cups
	virtual/pkgconfig
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXtst
	|| (
		dev-java/openjdk-bin:${SLOT}
		dev-java/icedtea-bin:${SLOT}
		dev-java/openjdk:${SLOT}
		dev-java/icedtea:${SLOT}
	)
"

PDEPEND="javafx? ( dev-java/openjfx:${SLOT} )"

PATCHES=( "${FILESDIR}/openjdk-8-insantiate-arrayallocator.patch" )

# The space required to build varies wildly depending on USE flags,
# ranging from 2GB to 16GB. This function is certainly not exact but
# should be close enough to be useful.
openjdk_check_requirements() {
	local M
	M=2048
	M=$(( $(usex debug 3 1) * $M ))
	M=$(( $(usex jbootstrap 2 1) * $M ))
	M=$(( $(usex doc 320 0) + $(usex source 128 0) + 192 + $M ))

	CHECKREQS_DISK_BUILD=${M}M check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	openjdk_check_requirements
	if [[ ${MERGE_TYPE} != binary ]]; then
		has ccache ${FEATURES} && die "FEATURES=ccache doesn't work with ${PN}, bug #677876"
	fi
}

pkg_setup() {
	openjdk_check_requirements

	JAVA_PKG_WANT_BUILD_VM="openjdk-${SLOT} openjdk-bin-${SLOT} icedtea-${SLOT} icedtea-bin-${SLOT}"
	JAVA_PKG_WANT_SOURCE="${SLOT}"
	JAVA_PKG_WANT_TARGET="${SLOT}"

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	default
	mv -v "jdk${SLOT}u"* "${P}" || die

	local repo
	for repo in corba hotspot jdk jaxp jaxws langtools nashorn; do
		mv -v "${repo}-"* "${P}/${repo}" || die
	done
}

src_prepare() {
	default

	# new warnings in new gcc https://bugs.gentoo.org/685426
	sed -i '/^WARNINGS_ARE_ERRORS/ s/-Werror/-Wno-error/' \
		hotspot/make/linux/makefiles/gcc.make || die

	chmod +x configure || die
}

src_configure() {
	# general build info found here:
	#https://hg.openjdk.java.net/jdk8/jdk8/raw-file/tip/README-builds.html

	# Work around stack alignment issue, bug #647954.
	use x86 && append-flags -mincoming-stack-boundary=2

	# Work around -fno-common ( GCC10 default ), bug #706638
	append-flags -fcommon

	# Strip some flags users may set, but should not. #818502
	filter-flags -fexceptions

	tc-export_build_env CC CXX PKG_CONFIG STRIP

	local myconf=(
			--disable-ccache
			--enable-unlimited-crypto
			--with-boot-jdk="${JDK_HOME}"
			--with-extra-cflags="${CFLAGS}"
			--with-extra-cxxflags="${CXXFLAGS}"
			--with-extra-ldflags="${LDFLAGS}"
			--with-giflib=system
			--with-jtreg=no
			--with-jobs=1
			--with-num-cores=1
			--with-update-version="$(ver_cut 2)"
			--with-build-number="b$(ver_cut 4)"
			--with-milestone="fcs" # magic variable that means "release version"
			--with-vendor-name="Gentoo"
			--with-vendor-url="https://gentoo.org"
			--with-vendor-bug-url="https://bugs.gentoo.org"
			--with-vendor-vm-bug-url="https://bugs.openjdk.java.net"
			--with-zlib=system
			--with-native-debug-symbols=$(usex debug internal none)
			$(usex headless-awt --disable-headful '')
			$(tc-is-clang && echo "--with-toolchain-type=clang")
		)

	# PaX breaks pch, bug #601016
	if use pch && ! host-is-pax; then
		myconf+=( --enable-precompiled-headers )
	else
		myconf+=( --disable-precompiled-headers )
	fi

	(
		unset _JAVA_OPTIONS JAVA JAVA_TOOL_OPTIONS JAVAC MAKE XARGS
		CFLAGS= CXXFLAGS= LDFLAGS= \
		CONFIG_SITE=/dev/null \
		CONFIG_SHELL="${EPREFIX}/bin/bash"
		econf "${myconf[@]}"
	)
}

src_compile() {
	local myemakeargs=(
		JOBS=$(makeopts_jobs)
		LOG=debug
		$(usex doc docs '')
		$(usex jbootstrap bootcycle-images images)
	)
	emake "${myemakeargs[@]}" -j1 #nowarn
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-${SLOT}"
	local ddest="${ED%/}/${dest#/}"

	cd "${S}"/build/*-release/images/j2sdk-image || die

	if ! use alsa; then
		rm -v jre/lib/$(get_system_arch)/libjsoundalsa.* || die
	fi

	# build system does not remove that
	if use headless-awt ; then
		rm -fvr jre/lib/$(get_system_arch)/lib*{[jx]awt,splashscreen}* \
		{,jre/}bin/policytool bin/appletviewer || die
	fi

	if ! use examples ; then
		rm -vr demo/ || die
	fi

	if ! use source ; then
		rm -v src.zip || die
	fi

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	dosym ../../../../../../etc/ssl/certs/java/cacerts "${dest}"/jre/lib/security/cacerts

	java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter

	if use doc ; then
		docinto html
		dodoc -r "${S}"/build/*-release/docs/*
	fi
}

pkg_postinst() {
	java-vm-2_pkg_postinst
	einfo "JavaWebStart functionality provided by icedtea-web package"
}
