# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/icedtea/icedtea-6.1.13.5.ebuild,v 1.4 2015/07/11 09:19:57 chewi Exp $
# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

# *********************************************************
# * IF YOU CHANGE THIS EBUILD, CHANGE ICEDTEA-7.* AS WELL *
# *********************************************************

EAPI="5"

inherit check-reqs java-pkg-2 java-vm-2 multiprocessing pax-utils prefix versionator virtualx

ICEDTEA_PKG=${PN}$(replace_version_separator 1 -)
ICEDTEA_BRANCH=$(get_version_component_range 1-3)
OPENJDK_BUILD="32"
OPENJDK_DATE="15_jul_2014"
OPENJDK_TARBALL="openjdk-6-src-b${OPENJDK_BUILD}-${OPENJDK_DATE}.tar.xz"
# Download cacao and jamvm regardless for use with EXTRA_ECONF
CACAO_TARBALL="68fe50ac34ec.tar.gz"
JAMVM_TARBALL="jamvm-ec18fb9e49e62dce16c5094ef1527eed619463aa.tar.gz"

CACAO_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-cacao-${CACAO_TARBALL}"
JAMVM_GENTOO_TARBALL="icedtea-${ICEDTEA_BRANCH}-${JAMVM_TARBALL}"

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
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

IUSE="+X +alsa cacao cjk +cups debug doc examples javascript +jbootstrap kerberos +nsplugin
	+nss pax_kernel pulseaudio selinux +source systemtap test +webstart"

# Ideally the following were optional at build time.
ALSA_COMMON_DEP="
	>=media-libs/alsa-lib-1.0"
CUPS_COMMON_DEP="
	>=net-print/cups-1.2.12"
X_COMMON_DEP="
	dev-libs/glib
	>=media-libs/freetype-2.3.5:2=
	>=x11-libs/gtk+-2.8:2=
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
	>=media-libs/giflib-4.1.6:=
	>=media-libs/libpng-1.2:0=
	>=sys-libs/zlib-1.2.3:=
	virtual/jpeg:0=
	>=media-libs/lcms-2.5
	javascript? ( dev-java/rhino:1.6 )
	kerberos? ( virtual/krb5 )
	nss? ( >=dev-libs/nss-3.12.5-r1 )
	pulseaudio?  ( >=media-sound/pulseaudio-0.9.11:= )
	systemtap? ( >=dev-util/systemtap-1 )"

# media-fonts/lklug needs ppc ppc64 keywords
RDEPEND="${COMMON_DEP}
	!dev-java/icedtea6
	X? (
		${X_COMMON_DEP}
		media-fonts/dejavu
		cjk? (
			media-fonts/arphicfonts
			media-fonts/baekmuk-fonts
			!ppc? ( !ppc64? ( media-fonts/lklug ) )
			media-fonts/lohit-fonts
			media-fonts/sazanami
		)
	)
	alsa? ( ${ALSA_COMMON_DEP} )
	cups? ( ${CUPS_COMMON_DEP} )
	selinux? ( sec-policy/selinux-java )"

# Only ant-core-1.8.1 has fixed ant -diagnostics when xerces+xalan are not present.
# ca-certificates, perl and openssl are used for the cacerts keystore generation
# xext headers have two variants depending on version - bug #288855
# !eclipse-ecj-3.7 - bug #392587
# autoconf - as long as we use eautoreconf, version restrictions for bug #294918
DEPEND="${COMMON_DEP} ${ALSA_COMMON_DEP} ${CUPS_COMMON_DEP} ${X_COMMON_DEP}
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
	virtual/pkgconfig
	sys-apps/lsb-release
	${X_DEPEND}
	pax_kernel? ( sys-apps/elfix )"

PDEPEND="webstart? ( || (
			dev-java/icedtea-web:0
			>=dev-java/icedtea-web-1.3.2:6
		) )
		nsplugin? ( || (
			dev-java/icedtea-web:0[nsplugin]
			>=dev-java/icedtea-web-1.3.2:6[nsplugin]
		) )"

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
		icedtea-6 icedtea-bin-6 icedtea6 icedtea6-bin
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

bootstrap_impossible() {
	# Fill this according to testing what works and what not
	has "${1}" # icedtea6 icedtea-6 icedtea6-bin icedtea-bin-6
}

src_configure() {
	local bootstrap config enable_cacao
	local vm=$(java-pkg_get-current-vm)

	# IcedTea6 can't be built using IcedTea7; its class files are too new
	# Whether to bootstrap
	bootstrap="disable"
	if use jbootstrap; then
		if bootstrap_impossible "${vm}"; then
			einfo "Bootstrap with ${vm} is currently not possible and thus disabled, ignoring USE=jbootstrap"
		else
			bootstrap="enable"
		fi
	fi

	if has "${vm}" gcj-jdk; then
		# gcj-jdk ensures ecj is present.
		use jbootstrap || einfo "bootstrap is necessary when building with ${vm}, ignoring USE=\"-jbootstrap\""
		bootstrap="enable"
	fi

	config+=" --${bootstrap}-bootstrap"

	# Always use HotSpot as the primary VM if available. #389521 #368669 #357633 ...
	# Otherwise use CACAO
	if ! has "${ARCH}" amd64 arm sparc x86; then
		enable_cacao=yes
	elif use cacao; then
		ewarn 'Enabling CACAO on an architecture with HotSpot support; issues may result.'
		ewarn 'If so, please rebuild with USE="-cacao"'
		enable_cacao=yes
	fi

	if [[ ${enable_cacao} ]]; then
		config+=" --enable-cacao"
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
		$(use_enable !debug optimizations) \
		$(use_enable doc docs) \
		$(use_enable kerberos system-kerberos) \
		$(use_enable nss) \
		$(use_enable pulseaudio pulse-java) \
		$(use_enable systemtap) \
		$(use_with pax_kernel pax "${EPREFIX}/usr/sbin/paxmark.sh")
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
	local ddest="${ED}/${dest}"
	dodir "${dest}"

	dodoc README NEWS AUTHORS
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}${SLOT}

	cd openjdk.build/j2sdk-image || die

	# Ensures HeadlessGraphicsEnvironment is used.
	if ! use X; then
		rm -r jre/lib/$(get_system_arch)/xawt || die
	fi

	# Don't hide classes
	rm lib/ct.sym || die

	#402507
	mkdir jre/.systemPrefs || die
	touch jre/.systemPrefs/.system.lock || die
	touch jre/.systemPrefs/.systemRootModFile || die

	# doins can't handle symlinks.
	cp -vRP bin include jre lib man "${ddest}" || die

	dodoc ASSEMBLY_EXCEPTION THIRD_PARTY_README

	if use doc; then
		# java-pkg_dohtml needed for package-list #302654
		java-pkg_dohtml -A dtd -r ../docs/* || die
	fi

	if use examples; then
		dodir "${dest}/share"
		cp -vRP demo sample "${ddest}/share/" || die
	fi

	if use source; then
		cp src.zip "${ddest}" || die
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

	# Bug 390663
	cp "${FILESDIR}"/fontconfig.Gentoo.properties.src "${T}"/fontconfig.Gentoo.properties || die
	eprefixify "${T}"/fontconfig.Gentoo.properties
	insinto "${dest}"/jre/lib
	doins "${T}"/fontconfig.Gentoo.properties

	set_java_env "${FILESDIR}/icedtea.env"
	if ! use X || ! use alsa || ! use cups; then
		java-vm_revdep-mask "${dest}"
	fi
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
