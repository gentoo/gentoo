# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit check-reqs flag-o-matic java-pkg-2 java-vm-2 multiprocessing pax-utils toolchain-funcs

# we need -ga tag to fetch tarball and unpack it, but exact number everywhere else to
# set build version properly
MY_PV="${PV%_p*}-ga"
SLOT="${MY_PV%%[.+]*}"

DESCRIPTION="Open source implementation of the Java programming language"
HOMEPAGE="https://openjdk.java.net"
SRC_URI="https://hg.${PN}.java.net/jdk-updates/jdk${SLOT}u/archive/jdk-${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 ~arm arm64 ppc64"

IUSE="alsa cups debug doc examples gentoo-vm headless-awt javafx +jbootstrap +pch selinux source systemtap"

COMMON_DEPEND="
	media-libs/freetype:2=
	media-libs/giflib:0/7
	media-libs/harfbuzz:=
	media-libs/libpng:0=
	media-libs/lcms:2=
	sys-libs/zlib
	virtual/jpeg:0=
	systemtap? ( dev-util/systemtap )
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
		x11-libs/libXrandr
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
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXtst
	javafx? ( dev-java/openjfx:${SLOT}= )
	|| (
		dev-java/openjdk-bin:${SLOT}
		dev-java/openjdk:${SLOT}
	)
"

REQUIRED_USE="javafx? ( alsa !headless-awt )"

S="${WORKDIR}/jdk${SLOT}u-jdk-${MY_PV}"

# The space required to build varies wildly depending on USE flags,
# ranging from 2GB to 16GB. This function is certainly not exact but
# should be close enough to be useful.
openjdk_check_requirements() {
	local M
	M=2048
	M=$(( $(usex jbootstrap 2 1) * $M ))
	M=$(( $(usex debug 3 1) * $M ))
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

	JAVA_PKG_WANT_BUILD_VM="openjdk-${SLOT} openjdk-bin-${SLOT}"
	JAVA_PKG_WANT_SOURCE="${SLOT}"
	JAVA_PKG_WANT_TARGET="${SLOT}"

	# The nastiness below is necessary while the gentoo-vm USE flag is
	# masked. First we call java-pkg-2_pkg_setup if it looks like the
	# flag was unmasked against one of the possible build VMs. If not,
	# we try finding one of them in their expected locations. This would
	# have been slightly less messy if openjdk-bin had been installed to
	# /opt/${PN}-${SLOT} or if there was a mechanism to install a VM env
	# file but disable it so that it would not normally be selectable.

	local vm
	for vm in ${JAVA_PKG_WANT_BUILD_VM}; do
		if [[ -d ${EPREFIX}/usr/lib/jvm/${vm} ]]; then
			java-pkg-2_pkg_setup
			return
		fi
	done

	if has_version --host-root dev-java/openjdk:${SLOT}; then
		export JDK_HOME=${EPREFIX}/usr/$(get_libdir)/openjdk-${SLOT}
	else
		if [[ ${MERGE_TYPE} != "binary" ]]; then
			JDK_HOME=$(best_version --host-root dev-java/openjdk-bin:${SLOT})
			[[ -n ${JDK_HOME} ]] || die "Build VM not found!"
			JDK_HOME=${JDK_HOME#*/}
			JDK_HOME=${EPREFIX}/opt/${JDK_HOME%-r*}
			export JDK_HOME
		fi
	fi
}

src_prepare() {
	default
	chmod +x configure || die
}

src_configure() {
	# Work around stack alignment issue, bug #647954. in case we ever have x86
	use x86 && append-flags -mincoming-stack-boundary=2

	# Work around -fno-common ( GCC10 default ), bug #713180
	append-flags -fcommon

	# Strip some flags users may set, but should not. #818502
	filter-flags -fexceptions

	# Enabling full docs appears to break doc building. If not
	# explicitly disabled, the flag will get auto-enabled if pandoc and
	# graphviz are detected. pandoc has loads of dependencies anyway.

	local myconf=(
		--disable-ccache
		--enable-full-docs=no
		--with-boot-jdk="${JDK_HOME}"
		--with-extra-cflags="${CFLAGS}"
		--with-extra-cxxflags="${CXXFLAGS}"
		--with-extra-ldflags="${LDFLAGS}"
		--with-freetype=system
		--with-giflib=system
		--with-harfbuzz=system
		--with-lcms=system
		--with-libjpeg=system
		--with-libpng=system
		--with-native-debug-symbols=$(usex debug internal none)
		--with-vendor-name="Gentoo"
		--with-vendor-url="https://gentoo.org"
		--with-vendor-bug-url="https://bugs.gentoo.org"
		--with-vendor-vm-bug-url="https://bugs.openjdk.java.net"
		--with-vendor-version-string="${PVR}"
		--with-version-pre=""
		--with-version-string="${PV%_p*}"
		--with-version-build="${PV#*_p}"
		--with-zlib=system
		--enable-dtrace=$(usex systemtap yes no)
		--enable-headless-only=$(usex headless-awt yes no)
		$(tc-is-clang && echo "--with-toolchain-type=clang")
	)

	if use javafx; then
		local zip="${EPREFIX%/}/usr/$(get_libdir)/openjfx-${SLOT}/javafx-exports.zip"
		if [[ -r ${zip} ]]; then
			myconf+=( --with-import-modules="${zip}" )
		else
			die "${zip} not found or not readable"
		fi
	fi

	# PaX breaks pch, bug #601016
	if use pch && ! host-is-pax; then
		myconf+=( --enable-precompiled-headers )
	else
		myconf+=( --disable-precompiled-headers )
	fi

	(
		unset _JAVA_OPTIONS JAVA JAVA_TOOL_OPTIONS JAVAC XARGS
		CFLAGS= CXXFLAGS= LDFLAGS= \
		CONFIG_SITE=/dev/null \
		econf "${myconf[@]}"
	)
}

src_compile() {
	local myemakeargs=(
		JOBS=$(makeopts_jobs)
		LOG=debug
		CFLAGS_WARNINGS_ARE_ERRORS= # No -Werror
		$(usex doc docs '')
		$(usex jbootstrap bootcycle-images product-images)
	)
	emake "${myemakeargs[@]}" -j1 #nowarn
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-${SLOT}"
	local ddest="${ED}${dest#/}"

	cd "${S}"/build/*-release/images/jdk || die

	# Create files used as storage for system preferences.
	mkdir .systemPrefs || die
	touch .systemPrefs/.system.lock || die
	touch .systemPrefs/.systemRootModFile || die

	# Oracle and IcedTea have libjsoundalsa.so depending on
	# libasound.so.2 but OpenJDK only has libjsound.so. Weird.
	if ! use alsa ; then
		rm -v lib/libjsound.* || die
	fi

	if ! use examples ; then
		rm -vr demo/ || die
	fi

	if ! use source ; then
		rm -v lib/src.zip || die
	fi

	rm -v lib/security/cacerts || die

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	dosym ../../../../../etc/ssl/certs/java/cacerts "${dest}"/lib/security/cacerts

	# must be done before running itself
	java-vm_set-pax-markings "${ddest}"

	einfo "Creating the Class Data Sharing archives and disabling usage tracking"
	"${ddest}/bin/java" -server -Xshare:dump -Djdk.disableLastUsageTracking || die

	use gentoo-vm && java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter

	if use doc ; then
		docinto html
		dodoc -r "${S}"/build/*-release/images/docs/*
		dosym ../../../usr/share/doc/"${PF}" /usr/share/doc/"${PN}-${SLOT}"
	fi
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	if use gentoo-vm ; then
		ewarn "WARNING! You have enabled the gentoo-vm USE flag, making this JDK"
		ewarn "recognised by the system. This will almost certainly break"
		ewarn "many java ebuilds as they are not ready for openjdk-11"
	else
		ewarn "The experimental gentoo-vm USE flag has not been enabled so this JDK"
		ewarn "will not be recognised by the system. For example, simply calling"
		ewarn "\"java\" will launch a different JVM. This is necessary until Gentoo"
		ewarn "fully supports Java ${SLOT}. This JDK must therefore be invoked using its"
		ewarn "absolute location under ${EPREFIX}/usr/$(get_libdir)/${PN}-${SLOT}."
	fi
}
