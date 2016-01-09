# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

# *********************************************************
# * IF YOU CHANGE THIS EBUILD, CHANGE ICEDTEA-7.* AS WELL *
# *********************************************************

EAPI="5"

inherit check-reqs java-pkg-2 java-vm-2 multiprocessing pax-utils versionator virtualx

ICEDTEA_PKG=${PN}$(replace_version_separator 1 -)
ICEDTEA_BRANCH=$(get_version_component_range 1-3)
OPENJDK_BUILD="37"
OPENJDK_DATE="11_nov_2015"
OPENJDK_TARBALL="openjdk-6-src-b${OPENJDK_BUILD}-${OPENJDK_DATE}.tar.xz"
# Download cacao and jamvm regardless for use with EXTRA_ECONF
CACAO_TARBALL="68fe50ac34ec.tar.gz"
JAMVM_TARBALL="jamvm-ec18fb9e49e62dce16c5094ef1527eed619463aa.tar.gz"

CACAO_GENTOO_TARBALL="icedtea-cacao-${CACAO_TARBALL}"
JAMVM_GENTOO_TARBALL="icedtea-${JAMVM_TARBALL}"

DESCRIPTION="A harness to build OpenJDK using Free Software build tools and dependencies"
HOMEPAGE="http://icedtea.classpath.org"
SRC_PKG="${ICEDTEA_PKG}.tar.xz"
SRC_URI="
	http://icedtea.classpath.org/download/source/${SRC_PKG}
	https://java.net/downloads/openjdk6/${OPENJDK_TARBALL}
	http://icedtea.classpath.org/download/drops/cacao/${CACAO_TARBALL} -> ${CACAO_GENTOO_TARBALL}
	http://icedtea.classpath.org/download/drops/jamvm/${JAMVM_TARBALL} -> ${JAMVM_GENTOO_TARBALL}"

LICENSE="Apache-1.1 Apache-2.0 GPL-1 GPL-2 GPL-2-with-linking-exception LGPL-2 MPL-1.0 MPL-1.1 public-domain W3C"
SLOT="6"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
RESTRICT="test"

IUSE="+alsa cacao cjk +cups debug doc examples +gtk headless-awt
	javascript +jbootstrap kerberos nsplugin +nss pax_kernel pulseaudio
	selinux source systemtap test webstart zero"

# Ideally the following were optional at build time.
ALSA_COMMON_DEP="
	>=media-libs/alsa-lib-1.0"
CUPS_COMMON_DEP="
	>=net-print/cups-1.2.12"
X_COMMON_DEP="
	>=media-libs/giflib-4.1.6:=
	>=media-libs/libpng-1.2:0=
	>=x11-libs/libX11-1.1.3
	>=x11-libs/libXext-1.1.1
	>=x11-libs/libXi-1.1.3
	>=x11-libs/libXrender-0.9.4
	>=x11-libs/libXtst-1.0.3
	x11-libs/libXt"
X_DEPEND="
	>=x11-libs/libXau-1.0.3
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXinerama-1.0.2
	x11-proto/inputproto
	>=x11-proto/xextproto-7.1.1
	x11-proto/xineramaproto
	x11-proto/xproto"

COMMON_DEP="
	>=media-libs/freetype-2.3.5:2=
	>=media-libs/lcms-2.5
	>=sys-libs/zlib-1.2.3:=
	virtual/jpeg:0=
	javascript? ( dev-java/rhino:1.6 )
	kerberos? ( virtual/krb5 )
	nss? ( >=dev-libs/nss-3.12.5-r1 )
	pulseaudio?  ( >=media-sound/pulseaudio-0.9.11:= )
	systemtap? ( >=dev-util/systemtap-1 )"

# media-fonts/lklug needs ppc ppc64 keywords
RDEPEND="${COMMON_DEP}
	!dev-java/icedtea6
	!dev-java/icedtea-web:6
	media-fonts/dejavu
	alsa? ( ${ALSA_COMMON_DEP} )
	cjk? (
		media-fonts/arphicfonts
		media-fonts/baekmuk-fonts
		media-fonts/lklug
		media-fonts/lohit-fonts
		media-fonts/sazanami
	)
	cups? ( ${CUPS_COMMON_DEP} )
	gtk? ( >=x11-libs/gtk+-2.8:2 )
	!headless-awt? ( ${X_COMMON_DEP} )
	selinux? ( sec-policy/selinux-java )"

# Only ant-core-1.8.1 has fixed ant -diagnostics when xerces+xalan are not present.
# ca-certificates, perl and openssl are used for the cacerts keystore generation
DEPEND="${COMMON_DEP} ${ALSA_COMMON_DEP} ${CUPS_COMMON_DEP} ${X_COMMON_DEP} ${X_DEPEND}
	|| (
		>=dev-java/gcj-jdk-4.3
		dev-java/icedtea-bin:6
		dev-java/icedtea:6
	)
	app-arch/cpio
	app-arch/unzip
	app-arch/zip
	app-misc/ca-certificates
	>=dev-java/ant-core-1.8.2
	dev-lang/perl
	>=dev-libs/libxslt-1.1.26
	dev-libs/openssl
	sys-apps/lsb-release
	virtual/pkgconfig
	pax_kernel? ( sys-apps/elfix )"

PDEPEND="webstart? ( dev-java/icedtea-web:0 )
	nsplugin? ( dev-java/icedtea-web:0[nsplugin] )"

S="${WORKDIR}"/${ICEDTEA_PKG}

icedtea_check_requirements() {
	local CHECKREQS_DISK_BUILD

	if use doc; then
		CHECKREQS_DISK_BUILD="8500M"
	else
		CHECKREQS_DISK_BUILD="8000M"
	fi

	check-reqs_pkg_${EBUILD_PHASE}
}

pkg_pretend() {
	icedtea_check_requirements
}

pkg_setup() {
	icedtea_check_requirements

	JAVA_PKG_WANT_BUILD_VM="
		icedtea-6 icedtea-bin-6
		gcj-jdk"
	JAVA_PKG_WANT_SOURCE="1.5"
	JAVA_PKG_WANT_TARGET="1.5"

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${SRC_PKG}
}

java_prepare() {
	# For bootstrap builds as the sandbox control file might not yet exist.
	addpredict /proc/self/coredump_filter

	# icedtea doesn't like some locales. #330433 #389717
	export LANG="C" LC_ALL="C"
}

src_configure() {
	local cacao_config config hotspot_port use_cacao use_zero zero_config
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

	# Use CACAO if requested
	if use cacao; then
		use_cacao="yes"
	fi

	# Are we on a architecture with a HotSpot port?
	# In-tree JIT ports are available for amd64, arm, sparc and x86.
	if { use amd64 || use arm || use sparc || use x86; }; then
		hotspot_port="yes"
	fi

	# Always use HotSpot as the primary VM if available. #389521 #368669 #357633 ...
	# Otherwise use CACAO on ppc and Zero on anything else
	if test "x${hotspot_port}" != "xyes"; then
		if { use ppc || use ppc64; }; then
			use_cacao="yes"
		else
			use_zero="yes"
		fi
	fi

	# Turn on CACAO if needed (non-HS archs) or requested
	if test "x${use_cacao}" = "xyes"; then
		if test "x${hotspot_port}" = "xyes"; then
			ewarn 'Enabling CACAO on an architecture with HotSpot support; issues may result.'
			ewarn 'If so, please rebuild with USE="-cacao"'
		fi
		cacao_config="--enable-cacao"

		# http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=2611
		export DISTRIBUTION_PATCHES="${SLOT}-cacao-pr-157.patch"
		ln -snf "${FILESDIR}/${DISTRIBUTION_PATCHES}" || die
	fi

	# Turn on Zero if needed (non-HS/CACAO archs) or requested
	if test "x${use_zero}" = "xyes"; then
		zero_config="--enable-zero"
	fi

	config+=" --with-parallel-jobs=$(makeopts_jobs)"

	if use javascript ; then
		config+=" --with-rhino=$(java-pkg_getjar rhino-1.6 js.jar)"
	else
		config+=" --without-rhino"
	fi

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf ${config} \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_TARBALL}" \
		--with-cacao-src-zip="${DISTDIR}/${CACAO_GENTOO_TARBALL}" \
		--with-jamvm-src-zip="${DISTDIR}/${JAMVM_GENTOO_TARBALL}" \
		--with-jdk-home="$(java-config -O)" \
		--with-abs-install-dir="${EPREFIX}/usr/$(get_libdir)/icedtea${SLOT}" \
		--with-pkgversion="Gentoo package ${PF}" \
		--disable-downloading --disable-Werror \
		$(use_enable !headless-awt system-gif) \
		$(use_enable !headless-awt system-png) \
		$(use_enable !debug optimizations) \
		$(use_enable doc docs) \
		$(use_enable kerberos system-kerberos) \
		$(use_enable nss) \
		$(use_with pax_kernel pax "${EPREFIX}/usr/sbin/paxmark.sh") \
		$(use_enable pulseaudio pulse-java) \
		$(use_enable systemtap) \
		${zero_config} ${cacao_config}
}

src_compile() {
	# Would use GENTOO_VM otherwise.
	export ANT_RESPECT_JAVA_HOME=TRUE

	# With ant >=1.8.2 all required tasks are part of ant-core
	export ANT_TASKS="none"

	emake
}

src_test() {
	# Use Xvfb for tests
	unset DISPLAY

	Xemake check
}

src_install() {
	local dest="/usr/$(get_libdir)/icedtea${SLOT}"
	local ddest="${ED}${dest#/}"
	dodir "${dest}"

	dodoc README NEWS AUTHORS
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}${SLOT}

	cd openjdk.build/j2sdk-image || die

	if ! use alsa; then
		rm -v jre/lib/$(get_system_arch)/libjsoundalsa.* || die
	fi

	if use headless-awt ; then
		rm -vr jre/lib/$(get_system_arch)/{xawt,libsplashscreen.*} \
		   {,jre/}bin/policytool bin/appletviewer || die
	fi

	# Don't hide classes
	rm lib/ct.sym || die

	#402507
	mkdir jre/.systemPrefs || die
	touch jre/.systemPrefs/.system.lock || die
	touch jre/.systemPrefs/.systemRootModFile || die

	# doins doesn't preserve executable bits.
	cp -vRP bin include jre lib man "${ddest}" || die

	dodoc ASSEMBLY_EXCEPTION THIRD_PARTY_README

	if use doc; then
		docinto html
		dodoc -r ../docs/*
	fi

	if use examples; then
		cp -vRP demo sample "${ddest}" || die
	fi

	if use source; then
		cp src.zip "${ddest}" || die
	fi

	# provided by icedtea-web but we need it in JAVA_HOME to work with run-java-tool
	if use webstart || use nsplugin; then
		dosym /usr/libexec/icedtea-web/itweb-settings ${dest}/bin/itweb-settings
		dosym /usr/libexec/icedtea-web/itweb-settings ${dest}/jre/bin/itweb-settings
	fi
	if use webstart; then
		dosym /usr/libexec/icedtea-web/javaws ${dest}/bin/javaws
		dosym /usr/libexec/icedtea-web/javaws ${dest}/jre/bin/javaws
	fi

	# Fix the permissions.
	find "${ddest}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	# Needs to be done before generating cacerts
	java-vm_set-pax-markings "${ddest}"

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

	set_java_env "${FILESDIR}/icedtea.env"
	java-vm_sandbox-predict /proc/self/coredump_filter
}

pkg_preinst() {
	if has_version "<=dev-java/icedtea-6.1.10.4:${SLOT}"; then
		# portage would preserve the symlink otherwise, related to bug #384397
		rm -f "${EROOT}/usr/lib/jvm/icedtea6"
		elog "To unify the layout and simplify scripts, the identifier of Icedtea-6*"
		elog "has changed from 'icedtea6' to 'icedtea-6' starting from version 6.1.10.4-r1"
		elog "If you had icedtea6 as system VM, the change should be automatic, however"
		elog "build VM settings in /etc/java-config-2/build/jdk.conf are not changed"
		elog "and the same holds for any user VM settings. Sorry for the inconvenience."
	fi
}
