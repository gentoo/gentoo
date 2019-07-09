# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

# *********************************************************
# * IF YOU CHANGE THIS EBUILD, CHANGE ICEDTEA-6.* AS WELL *
# *********************************************************

EAPI="6"
SLOT="8"

inherit check-reqs flag-o-matic java-pkg-2 java-vm-2 multiprocessing pax-utils prefix versionator xdg-utils

ICEDTEA_VER=$(get_version_component_range 1-3)
ICEDTEA_BRANCH=$(get_version_component_range 1-2)
ICEDTEA_PKG=icedtea-${ICEDTEA_VER}
ICEDTEA_PRE=$(get_version_component_range _)

CORBA_TARBALL="fa1553d2f23e.tar.xz"
JAXP_TARBALL="7a977b82f34c.tar.xz"
JAXWS_TARBALL="752d9e54c69a.tar.xz"
JDK_TARBALL="bfaa5c6df4a8.tar.xz"
LANGTOOLS_TARBALL="fb494039358f.tar.xz"
OPENJDK_TARBALL="f0482b9b7f7b.tar.xz"
NASHORN_TARBALL="93462e8b4f4f.tar.xz"
HOTSPOT_TARBALL="3f9a60eb8ef0.tar.xz"
SHENANDOAH_TARBALL="adb62c0031b8.tar.xz"
AARCH32_TARBALL="57f4048a925b.tar.xz"

CACAO_TARBALL="cacao-c182f119eaad.tar.xz"
JAMVM_TARBALL="jamvm-ec18fb9e49e62dce16c5094ef1527eed619463aa.tar.gz"

CORBA_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-corba-${CORBA_TARBALL}"
JAXP_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxp-${JAXP_TARBALL}"
JAXWS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jaxws-${JAXWS_TARBALL}"
JDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-jdk-${JDK_TARBALL}"
LANGTOOLS_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-langtools-${LANGTOOLS_TARBALL}"
OPENJDK_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-openjdk-${OPENJDK_TARBALL}"
NASHORN_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-nashorn-${NASHORN_TARBALL}"
HOTSPOT_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-hotspot-${HOTSPOT_TARBALL}"
SHENANDOAH_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-shenandoah-${SHENANDOAH_TARBALL}"
AARCH32_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-aarch32-${AARCH32_TARBALL}"

CACAO_GENTOO_TARBALL="icedtea-${CACAO_TARBALL}"
JAMVM_GENTOO_TARBALL="icedtea-${JAMVM_TARBALL}"

DROP_URL="https://icedtea.classpath.org/download/drops"
ICEDTEA_URL="${DROP_URL}/icedtea${SLOT}/${ICEDTEA_VER}"

DESCRIPTION="A harness to build OpenJDK using Free Software build tools and dependencies"
HOMEPAGE="https://icedtea.classpath.org"
SRC_PKG="${ICEDTEA_PKG}.tar.xz"
SRC_URI="
	https://icedtea.classpath.org/download/source/${SRC_PKG}
	${ICEDTEA_URL}/openjdk.tar.xz -> ${OPENJDK_GENTOO_TARBALL}
	${ICEDTEA_URL}/corba.tar.xz -> ${CORBA_GENTOO_TARBALL}
	${ICEDTEA_URL}/jaxp.tar.xz -> ${JAXP_GENTOO_TARBALL}
	${ICEDTEA_URL}/jaxws.tar.xz -> ${JAXWS_GENTOO_TARBALL}
	${ICEDTEA_URL}/jdk.tar.xz -> ${JDK_GENTOO_TARBALL}
	${ICEDTEA_URL}/hotspot.tar.xz -> ${HOTSPOT_GENTOO_TARBALL}
	${ICEDTEA_URL}/nashorn.tar.xz -> ${NASHORN_GENTOO_TARBALL}
	${ICEDTEA_URL}/langtools.tar.xz -> ${LANGTOOLS_GENTOO_TARBALL}
	shenandoah? ( ${ICEDTEA_URL}/shenandoah.tar.xz -> ${SHENANDOAH_GENTOO_TARBALL} )
	arm? ( ${ICEDTEA_URL}/aarch32.tar.xz -> ${AARCH32_GENTOO_TARBALL} )
	${DROP_URL}/cacao/${CACAO_TARBALL} -> ${CACAO_GENTOO_TARBALL}
	${DROP_URL}/jamvm/${JAMVM_TARBALL} -> ${JAMVM_GENTOO_TARBALL}"

LICENSE="Apache-1.1 Apache-2.0 GPL-1 GPL-2 GPL-2-with-linking-exception LGPL-2 MPL-1.0 MPL-1.1 public-domain W3C"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

IUSE="+alsa cacao +cups doc examples +gtk headless-awt
	jamvm +jbootstrap kerberos libressl nsplugin pax_kernel +pch
	pulseaudio sctp selinux shenandoah smartcard +source +system-lcms test +webstart zero"

REQUIRED_USE="gtk? ( !headless-awt )"

# Ideally the following were optional at build time.
ALSA_COMMON_DEP="
	>=media-libs/alsa-lib-1.0"
CUPS_COMMON_DEP="
	>=net-print/cups-1.2.12"
X_COMMON_DEP="
	>=media-libs/giflib-4.1.6:0=
	>=media-libs/libpng-1.2:0=
	>=x11-libs/libX11-1.1.3
	>=x11-libs/libXext-1.1.1
	>=x11-libs/libXi-1.1.3
	>=x11-libs/libXrender-0.9.4
	>=x11-libs/libXtst-1.0.3
	x11-libs/libXcomposite"
X_DEPEND="
	x11-base/xorg-proto
	>=x11-libs/libXau-1.0.3
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXinerama-1.0.2"

# The Javascript requirement is obsolete; OpenJDK 8+ has Nashorn
COMMON_DEP="
	>=dev-libs/glib-2.26:2=
	>=dev-util/systemtap-1
	media-libs/fontconfig:1.0=
	>=media-libs/freetype-2.5.3:2=
	>=sys-libs/zlib-1.2.3
	virtual/jpeg:0=
	kerberos? ( virtual/krb5 )
	sctp? ( net-misc/lksctp-tools )
	smartcard? ( sys-apps/pcsc-lite )
	system-lcms? ( >=media-libs/lcms-2.9:2= )"

# Gtk+ will move to COMMON_DEP in time; PR1982
# gsettings-desktop-schemas will be needed for native proxy support; PR1976
RDEPEND="${COMMON_DEP}
	!dev-java/icedtea:0
	!dev-java/icedtea-web:7
	>=gnome-base/gsettings-desktop-schemas-3.12.2
	virtual/ttf-fonts
	alsa? ( ${ALSA_COMMON_DEP} )
	cups? ( ${CUPS_COMMON_DEP} )
	gtk? (
		>=dev-libs/atk-1.30.0
		>=x11-libs/cairo-1.8.8
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.8:2
		>=x11-libs/pango-1.24.5
	)
	!headless-awt? ( ${X_COMMON_DEP} )
	selinux? ( sec-policy/selinux-java )"

# ca-certificates, perl and openssl are used for the cacerts keystore generation
# perl is needed for running the SystemTap tests and the bootstrap javac
# lsb-release is used to obtain distro information for the version & crash dump output
# attr is needed for xattr.h which defines the extended attribute syscalls used by NIO2
# x11-libs/libXt is needed for headers only (Intrinsic.h, IntrinsicP.h, Shell.h, StringDefs.h)
# Ant is no longer needed under the new build system
DEPEND="${COMMON_DEP} ${ALSA_COMMON_DEP} ${CUPS_COMMON_DEP} ${X_COMMON_DEP} ${X_DEPEND}
	|| (
		dev-java/icedtea-bin:8
		dev-java/icedtea-bin:7
		dev-java/icedtea:8
		dev-java/icedtea:7
		dev-java/openjdk:8
		dev-java/openjdk-bin:8
	)
	app-arch/cpio
	app-arch/unzip
	app-arch/zip
	app-misc/ca-certificates
	dev-lang/perl
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl:0 )
	sys-apps/attr
	sys-apps/lsb-release
	x11-libs/libXt
	virtual/pkgconfig
	pax_kernel? ( sys-apps/elfix )"

PDEPEND="webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )
	pulseaudio? ( dev-java/icedtea-sound )"

S="${WORKDIR}"/${ICEDTEA_PKG}

icedtea_check_requirements() {
	local CHECKREQS_DISK_BUILD

	if use doc; then
		CHECKREQS_DISK_BUILD="9000M"
	else
		CHECKREQS_DISK_BUILD="8500M"
	fi

	check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	icedtea_check_requirements
}

pkg_setup() {
	icedtea_check_requirements

	JAVA_PKG_WANT_BUILD_VM="
		icedtea-8 icedtea-bin-8
		icedtea-7 icedtea-bin-7
		openjdk-8 openjdk-bin-8"
	JAVA_PKG_WANT_SOURCE="1.5"
	JAVA_PKG_WANT_TARGET="1.5"

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${SRC_PKG}
}

src_configure() {
	# For bootstrap builds as the sandbox control file might not yet exist.
	addpredict /proc/self/coredump_filter

	# icedtea doesn't like some locales. #330433 #389717
	export LANG="C" LC_ALL="C"

	local cacao_config config hotspot_port hs_config jamvm_config use_cacao use_jamvm use_zero zero_config
	local vm=$(java-pkg_get-current-vm)

	# gcj-jdk ensures ecj is present.
	if use jbootstrap || has "${vm}" gcj-jdk; then
		use jbootstrap || einfo "bootstrap is necessary when building with ${vm}, ignoring USE=\"-jbootstrap\""
		config+=" --enable-bootstrap"
	else
		config+=" --disable-bootstrap"
	fi

	# Use Zero if requested
	if use zero; then
		use_zero="yes"
	fi

	# Use JamVM if requested
	if use jamvm; then
		use_jamvm="yes"
	fi

	# Use CACAO if requested
	if use cacao; then
		use_cacao="yes"
	fi

	# Are we on a architecture with a HotSpot port?
	# In-tree JIT ports are available for amd64, arm, arm64, ppc64 (be&le), SPARC and x86.
	if { use amd64 || use arm || use arm64 || use ppc64 || use sparc || use x86; }; then
		hotspot_port="yes"
		# Work around stack alignment issue, bug #647954.
		use x86 && append-flags -mincoming-stack-boundary=2
	fi

	# Always use HotSpot as the primary VM if available. #389521 #368669 #357633 ...
	# Otherwise use Zero for now until alternate VMs are working
	if test "x${hotspot_port}" != "xyes"; then
			use_zero="yes"
	fi

	if use shenandoah; then
		if { use amd64 || use arm64; }; then
			hs_config="--with-hotspot-build=shenandoah"
			hs_config+=" --with-hotspot-src-zip="${DISTDIR}/${SHENANDOAH_GENTOO_TARBALL}""
		else
			eerror "Shenandoah is only supported on arm64 and x86_64. Please re-build with USE="-shenandoah""
		fi
	else
		if use arm ; then
			hs_config="--with-hotspot-src-zip="${DISTDIR}/${AARCH32_GENTOO_TARBALL}""
		else
			hs_config="--with-hotspot-src-zip="${DISTDIR}/${HOTSPOT_GENTOO_TARBALL}""
		fi
	fi

	# Turn on JamVM if needed (non-HS archs) or requested
	if test "x${use_jamvm}" = "xyes"; then
		if test "x${hotspot_port}" = "xyes"; then
			ewarn 'Enabling JamVM on an architecture with HotSpot support; issues may result.'
			ewarn 'If so, please rebuild with USE="-jamvm"'
		fi
		ewarn 'JamVM is known to still have issues with IcedTea 3.x; please rebuild with USE="-jamvm"'
		jamvm_config="--enable-jamvm"
	fi

	# Turn on CACAO if needed (non-HS archs) or requested
	if test "x${use_cacao}" = "xyes"; then
		if test "x${hotspot_port}" = "xyes"; then
			ewarn 'Enabling CACAO on an architecture with HotSpot support; issues may result.'
			ewarn 'If so, please rebuild with USE="-cacao"'
		fi
		ewarn 'CACAO is known to still have issues with IcedTea 3.x; please rebuild with USE="-cacao"'
		cacao_config="--enable-cacao"
	fi

	# Turn on Zero if needed (non-HS/CACAO archs) or requested
	if test "x${use_zero}" = "xyes"; then
		if test "x${hotspot_port}" = "xyes"; then
			ewarn 'Enabling Zero on an architecture with HotSpot support; performance will be significantly reduced.'
		fi
		zero_config="--enable-zero"
	fi

	# PaX breaks pch, bug #601016
	if use pch && ! host-is-pax; then
		config+=" --enable-precompiled-headers"
	else
		config+=" --disable-precompiled-headers"
	fi

	config+=" --with-parallel-jobs=$(makeopts_jobs)"

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf ${config} \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_GENTOO_TARBALL}" \
		--with-corba-src-zip="${DISTDIR}/${CORBA_GENTOO_TARBALL}" \
		--with-jaxp-src-zip="${DISTDIR}/${JAXP_GENTOO_TARBALL}" \
		--with-jaxws-src-zip="${DISTDIR}/${JAXWS_GENTOO_TARBALL}" \
		--with-jdk-src-zip="${DISTDIR}/${JDK_GENTOO_TARBALL}" \
		--with-langtools-src-zip="${DISTDIR}/${LANGTOOLS_GENTOO_TARBALL}" \
		--with-nashorn-src-zip="${DISTDIR}/${NASHORN_GENTOO_TARBALL}" \
		--with-cacao-src-zip="${DISTDIR}/${CACAO_GENTOO_TARBALL}" \
		--with-jamvm-src-zip="${DISTDIR}/${JAMVM_GENTOO_TARBALL}" \
		--with-jdk-home="$(java-config -O)" \
		--prefix="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}" \
		--mandir="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}/man" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--with-pkgversion="Gentoo ${PF}" \
		--disable-ccache \
		--disable-downloading --disable-Werror --disable-tests \
		--disable-systemtap-tests --enable-improved-font-rendering \
		--enable-system-jpeg --enable-system-zlib \
		$(use_enable headless-awt headless) \
		$(use_enable !headless-awt system-gif) \
		$(use_enable !headless-awt system-png) \
		$(use_enable doc docs) \
		$(use_enable kerberos system-kerberos) \
		$(use_enable system-lcms) \
		$(use_with pax_kernel pax "${EPREFIX}/usr/sbin/paxmark.sh") \
		$(use_enable sctp system-sctp) \
		$(use_enable smartcard system-pcsc) \
		${zero_config} ${cacao_config} ${jamvm_config} ${hs_config}
}

src_compile() {
	default
}

src_test() {
	default
}

src_install() {
	default

	local dest="/usr/$(get_libdir)/icedtea${SLOT}"
	local ddest="${ED}${dest#/}"

	if ! use alsa; then
		rm -v "${ddest}"/jre/lib/$(get_system_arch)/libjsoundalsa.* || die
	fi

	if ! use examples; then
		rm -r "${ddest}"/demo "${ddest}"/sample || die
	fi

	if ! use source; then
		rm -v "${ddest}"/src.zip || die
	fi

	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}${SLOT}

	# Fix the permissions.
	find "${ddest}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	# We need to generate keystore - bug #273306
	einfo "Generating cacerts file from certificates in ${EPREFIX}/usr/share/ca-certificates/"
	mkdir "${T}/certgen" && cd "${T}/certgen" || die
	cp "${FILESDIR}/generate-cacerts.pl" . && chmod +x generate-cacerts.pl || die
	for c in "${EPREFIX}"/usr/share/ca-certificates/*/*.crt; do
		openssl x509 -text -in "${c}" >> all.crt || die
	done
	./generate-cacerts.pl "${ddest}/bin/keytool" all.crt || die
	cp -vRP cacerts "${ddest}/jre/lib/security/" || die
	chmod 644 "${ddest}/jre/lib/security/cacerts" || die

	java-vm_install-env "${FILESDIR}/icedtea.env.sh"
	java-vm_sandbox-predict /proc/self/coredump_filter
}

pkg_postinst() {
	xdg_icon_cache_update
	java-vm-2_pkg_postinst
}

pkg_postrm() {
	xdg_icon_cache_update
	java-vm-2_pkg_postrm
}
