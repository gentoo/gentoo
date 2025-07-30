# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Avoid circular dependency
JAVA_DISABLE_DEPEND_ON_JAVA_DEP_CHECK="true"

inherit check-reqs flag-o-matic java-pkg-2 java-vm-2 multiprocessing toolchain-funcs

# don't change versioning scheme
# to find correct _p number, look at
# https://github.com/openjdk/jdk${SLOT}u/tags
# you will see, for example, jdk-17.0.4.1-ga and jdk-17.0.4.1+1, both point
# to exact same commit sha. we should always use the full version.
# -ga tag is just for humans to easily identify General Availability release tag.
# we need -ga tag to fetch tarball and unpack it, but exact number everywhere else to
# set build version properly
MY_PV="$(ver_rs 1 'u' 2 '-' ${PV%_p*}-ga)"

# variable name format: <UPPERCASE_KEYWORD>_XPAK
X86_XPAK="8.402_p06"
PPC64_XPAK="8.402_p06"

# Usage: bootstrap_uri <keyword> <version> [extracond]
# Example: $(bootstrap_uri x86 8.402_p06)
# Output: ppc64? ( big-endian? ( https://...8.402_p06-x86.tar.xz ) )
bootstrap_uri() {
	local baseuri="https://dev.gentoo.org/~arthurzam/distfiles/dev-java/${PN}/${PN}-bootstrap"
	local suff="tar.xz"
	local kw="${1:?${FUNCNAME[0]}: keyword not specified}"
	local ver="${2:?${FUNCNAME[0]}: version not specified}"
	local cond="${3-}"

	# here be dragons
	echo "${kw}? ( ${cond:+${cond}? (} ${baseuri}-${ver}-${kw}.${suff} ${cond:+) })"
}

DESCRIPTION="Open source implementation of the Java programming language"
HOMEPAGE="https://openjdk.org"
SRC_URI="
	https://github.com/openjdk/jdk8u/archive/jdk${MY_PV}.tar.gz
		-> ${P}.tar.gz
	!system-bootstrap? (
		$(bootstrap_uri x86 ${X86_XPAK})
		$(bootstrap_uri ppc64 ${PPC64_XPAK} big-endian)
	)
"
S="${WORKDIR}/jdk${SLOT}u-jdk${MY_PV}"

LICENSE="GPL-2-with-classpath-exception"
SLOT="${PV%%[.+]*}"
KEYWORDS="~amd64 arm64 ppc64 ~x86"
IUSE="alsa big-endian debug cups doc examples headless-awt javafx +jbootstrap selinux system-bootstrap source"

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
	system-bootstrap? (
		|| (
			dev-java/openjdk-bin:${SLOT}
			dev-java/openjdk:${SLOT}
		)
	)
"

BDEPEND="
	virtual/pkgconfig
	sys-devel/gcc:*
"

PDEPEND="javafx? ( dev-java/openjfx:${SLOT} )"

PATCHES=(
	"${FILESDIR}/openjdk-8-insantiate-arrayallocator.patch"
	"${FILESDIR}/openjdk-8.402_p06-0001-Fix-Wint-conversion.patch"
	"${FILESDIR}/openjdk-8.402_p06-0002-Fix-Wincompatible-pointer-types.patch"
	"${FILESDIR}/openjdk-8.402_p06-0003-Fix-negative-value-left-shift.patch"
	"${FILESDIR}/openjdk-8.402_p06-0004-Fix-misc.-warnings.patch"
)

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
	java-vm-2_pkg_setup

	[[ ${MERGE_TYPE} == "binary" ]] && return

	JAVA_PKG_WANT_BUILD_VM="openjdk-${SLOT} openjdk-bin-${SLOT}"
	JAVA_PKG_WANT_SOURCE="${SLOT}"
	JAVA_PKG_WANT_TARGET="${SLOT}"

	if use system-bootstrap; then
		for vm in ${JAVA_PKG_WANT_BUILD_VM}; do
			if [[ -d ${BROOT}/usr/lib/jvm/${vm} ]]; then
				java-pkg-2_pkg_setup
				return
			fi
		done
	fi
}

src_prepare() {
	default

	# new warnings in new gcc https://bugs.gentoo.org/685426
	sed -i '/^WARNINGS_ARE_ERRORS/ s/-Werror/-Wno-error/' \
		hotspot/make/linux/makefiles/gcc.make || die

	chmod +x configure || die

	# Force gcc because build failed with modern clang, #918655
	if ! tc-is-gcc; then
			ewarn "openjdk/8 can be built with gcc only."
			ewarn "Ignoring CC=$(tc-getCC) and forcing ${CHOST}-gcc"
			export CC=${CHOST}-gcc
			export CXX=${CHOST}-g++
			tc-is-gcc || die "tc-is-gcc failed in spite of CC=${CC}"
	fi
}

src_configure() {
	local myconf=()

	if ! use system-bootstrap; then
		local xpakvar="${ARCH^^}_XPAK"
		export JDK_HOME="${WORKDIR}/openjdk-bootstrap-${!xpakvar}"
	fi

	# general build info found here:
	# https://hg.openjdk.java.net/jdk8/jdk8/raw-file/tip/README-builds.html

	# -Wregister use (bug #918655)
	append-cxxflags -std=gnu++14

	# Work around stack alignment issue, bug #647954.
	use x86 && append-flags -mincoming-stack-boundary=2

	# Strip some flags users may set, but should not. #818502
	filter-flags -fexceptions

	# Strip lto related flags, we rely on --with-jvm-features=link-time-opt
	# See bug #833097 and bug #833098.
	tc-is-lto && myconf+=( --with-jvm-features=link-time-opt )
	filter-lto
	filter-flags -fdevirtualize-at-ltrans

	# bug #954888
	append-cflags -std=gnu17

	tc-export_build_env CC CXX PKG_CONFIG STRIP

	myconf+=(
			--disable-ccache
			--disable-freetype-bundling
			--disable-precompiled-headers
			--enable-unlimited-crypto
			--with-boot-jdk="${JDK_HOME}"
			--with-extra-cflags="${CFLAGS}"
			--with-extra-cxxflags="${CXXFLAGS}"
			--with-extra-ldflags="${LDFLAGS}"
			--with-freetype-lib="$( $(tc-getPKG_CONFIG) --variable=libdir freetype2 )"
			--with-freetype-include="$( $(tc-getPKG_CONFIG) --variable=includedir freetype2)/freetype2"
			--with-giflib="${XPAK_BOOTSTRAP:-system}"
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
			--with-zlib="${XPAK_BOOTSTRAP:-system}"
			--with-native-debug-symbols=$(usex debug internal none)
			$(usex headless-awt --disable-headful '')
			$(tc-is-clang && echo "--with-toolchain-type=clang")
		)

	(
		unset _JAVA_OPTIONS JAVA JAVA_TOOL_OPTIONS JAVAC MAKE XARGS
		CFLAGS= CXXFLAGS= LDFLAGS= \
		CONFIG_SITE=/dev/null \
		CONFIG_SHELL="${BROOT}/bin/bash"
		econf "${myconf[@]}"
	)
}

src_compile() {
	# Too brittle - gets confused by e.g. -Oline
	export MAKEOPTS="-j$(makeopts_jobs) -l$(makeopts_loadavg)"
	unset GNUMAKEFLAGS MAKEFLAGS

	local myemakeargs=(
		JOBS=$(makeopts_jobs)
		LOG=debug
		CFLAGS_WARNINGS_ARE_ERRORS= # No -Werror
		NICE= # Use PORTAGE_NICENESS, don't adjust further down
		$(usex doc docs '')
		$(usex jbootstrap bootcycle-images images)
	)
	emake "${myemakeargs[@]}" -j1
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-${SLOT}"
	local ddest="${ED}/${dest#/}"

	# https://bugs.gentoo.org/922741
	docompress "${dest}/man"

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

	dosym -r /etc/ssl/certs/java/cacerts "${dest}"/jre/lib/security/cacerts

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
