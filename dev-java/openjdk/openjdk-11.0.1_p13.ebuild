# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools check-reqs flag-o-matic java-pkg-2 java-vm-2 multiprocessing pax-utils toolchain-funcs

MY_PV=${PV/_p/+}
SLOT=${MY_PV%%[.+]*}

DESCRIPTION="Open source implementation of the Java programming language"
HOMEPAGE="https://openjdk.java.net"
SRC_URI="https://hg.${PN}.java.net/jdk-updates/jdk${SLOT}u/archive/jdk-${MY_PV}.tar.bz2"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm64 ~ppc64"

# Default variant must be first!
# The rest do not matter.
JVM_VARIANTS="
	server
	client
	core
	minimal
	zero
"

IUSE=$(printf "jvm_variant_%s " ${JVM_VARIANTS})

REQUIRED_USE="
	|| ( ${IUSE} )
	?? ( jvm_variant_core jvm_variant_zero )
	jvm_variant_core? ( !jvm_variant_server !jvm_variant_client !jvm_variant_minimal )
	jvm_variant_zero? ( !jvm_variant_server !jvm_variant_client !jvm_variant_minimal )
"

IUSE="+${IUSE} alsa debug doc examples gentoo-vm headless-awt +jbootstrap nsplugin +pch selinux source systemtap +webstart"

CDEPEND="
	media-libs/freetype:2=
	net-print/cups
	sys-libs/zlib
	systemtap? ( dev-util/systemtap )
	!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXt
		x11-libs/libXtst
	)
"

RDEPEND="
	${CDEPEND}
	alsa? ( media-libs/alsa-lib )
	selinux? ( sec-policy/selinux-java )
"

DEPEND="
	${CDEPEND}
	app-arch/zip
	media-libs/alsa-lib
	!headless-awt? (
		x11-base/xorg-proto
	)
	|| (
		dev-java/openjdk-bin:${SLOT}
		dev-java/openjdk:${SLOT}
	)
"

PDEPEND="webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )"

S="${WORKDIR}/jdk${SLOT}u-jdk-${MY_PV}"

# The space required to build varies wildly depending on USE flags,
# ranging from 2GB to 24GB. This function is certainly not exact but
# should be close enough to be useful.
openjdk_check_requirements() {
	local M variant count=0

	for variant in ${JVM_VARIANTS}; do
		use jvm_variant_${variant} &&
			count=$(( $count + 1 ))
	done

	M=$(usex debug 2600 875)
	M=$(( $(usex debug 2900 375) * $count + $M ))
	M=$(( $(usex jbootstrap 2 1) * $M ))
	M=$(( $(usex doc 300 0) + $(usex source 120 0) + 820 + $M ))

	CHECKREQS_DISK_BUILD=${M}M check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	openjdk_check_requirements
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
		JDK_HOME=$(best_version --host-root dev-java/openjdk-bin:${SLOT})
		[[ -n ${JDK_HOME} ]] || die "Build VM not found!"
		JDK_HOME=${JDK_HOME#*/}
		JDK_HOME=${EPREFIX}/opt/${JDK_HOME%-r*}
		export JDK_HOME
	fi
}

src_configure() {
	# Work around stack alignment issue, bug #647954.
	use x86 && append-flags -mincoming-stack-boundary=2

	chmod +x configure || die

	local variant build_variants
	for variant in ${JVM_VARIANTS}; do
		use jvm_variant_${variant} &&
			build_variants+=${variant},
	done

	local myconf=()

	# PaX breaks pch, bug #601016
	if use pch && ! host-is-pax; then
		myconf+=( --enable-precompiled-headers )
	else
		myconf+=( --disable-precompiled-headers )
	fi

	# Enabling full docs appears to break doc building. If not
	# explicitly disabled, the flag will get auto-enabled if pandoc and
	# graphviz are detected. pandoc has loads of dependencies anyway.

	(
		unset JAVA JAVAC XARGS
		CFLAGS= CXXFLAGS= LDFLAGS= \
		CONFIG_SITE=/dev/null \
		econf \
			--with-boot-jdk="${JDK_HOME}" \
			--with-extra-cflags="${CFLAGS}" \
			--with-extra-cxxflags="${CXXFLAGS}" \
			--with-extra-ldflags="${LDFLAGS}" \
			--with-jvm-variants=${build_variants%,} \
			--with-native-debug-symbols=$(usex debug internal none) \
			--with-version-pre=gentoo \
			--with-version-string=${MY_PV%+*} \
			--with-version-build=${MY_PV#*+} \
			--enable-dtrace=$(usex systemtap yes no) \
			--enable-headless-only=$(usex headless-awt yes no) \
			--enable-full-docs=no \
			--disable-ccache \
			"${myconf[@]}"
	)
}

src_compile() {
	emake -j1 \
		$(usex jbootstrap bootcycle-images product-images) $(usex doc docs '') \
		JOBS=$(makeopts_jobs) LOG=debug CFLAGS_WARNINGS_ARE_ERRORS= # No -Werror
}

src_install() {
	local dest="/usr/$(get_libdir)/${PN}-${SLOT}"
	local ddest="${ED}${dest#/}"

	cd "${S}"/build/*-release/images/jdk || die

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

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	use gentoo-vm && java-vm_install-env "${FILESDIR}"/${PN}-${SLOT}.env.sh
	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter

	if use doc ; then
		insinto /usr/share/doc/${PF}/html
		doins -r "${S}"/build/*-release/images/docs/*
		dosym ${PF} /usr/share/doc/${PN}-${SLOT}
	fi
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	if use gentoo-vm ; then
		ewarn "WARNING! You have enabled the gentoo-vm USE flag, making this JDK"
		ewarn "recognised by the system. This will almost certainly break things."
	else
		ewarn "The experimental gentoo-vm USE flag has not been enabled so this JDK"
		ewarn "will not be recognised by the system. For example, simply calling"
		ewarn "\"java\" will launch a different JVM. This is necessary until Gentoo"
		ewarn "fully supports Java ${SLOT}. This JDK must therefore be invoked using its"
		ewarn "absolute location under ${EPREFIX}/usr/$(get_libdir)/${PN}-${SLOT}."
	fi
}
