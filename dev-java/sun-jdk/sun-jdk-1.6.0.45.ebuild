# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.6.0.45.ebuild,v 1.4 2014/05/16 19:03:59 swift Exp $

EAPI="5"

inherit eutils java-vm-2 prefix versionator

# This URIs need to be updated when bumping!
JDK_URI="http://www.oracle.com/technetwork/java/javase/downloads/jdk6downloads-1902814.html"
JCE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jce-6-download-429243.html"
# This is a list of archs supported by this update. Currently ia64 comes and goes ...
AT_AVAILABLE=( amd64 ia64 x86 x64-solaris x86-solaris sparc-solaris sparc64-solaris )
# somtimes the demos are missing
DEMOS_AVAILABLE=( amd64 ia64 x86 x64-solaris x86-solaris sparc-solaris sparc64-solaris )

MY_PV="$(get_version_component_range 2)u$(get_version_component_range 4)"
S_PV="$(replace_version_separator 3 '_')"

AT_x86="jdk-${MY_PV}-linux-i586.bin"
AT_amd64="jdk-${MY_PV}-linux-x64.bin"
AT_ia64="jdk-${MY_PV}-linux-ia64.bin"
AT_x86_solaris="jdk-${MY_PV}-solaris-i586.sh"
AT_x64_solaris="${AT_x86_solaris} jdk-${MY_PV}-solaris-x64.sh"
AT_sparc_solaris="jdk-${MY_PV}-solaris-sparc.sh"
AT_sparc64_solaris="${AT_sparc_solaris} jdk-${MY_PV}-solaris-sparcv9.sh"

DEMOS_x86="jdk-${MY_PV}-linux-i586-demos.tar.gz"
DEMOS_amd64="jdk-${MY_PV}-linux-x64-demos.tar.gz"
DEMOS_ia64="jdk-${MY_PV}-linux-ia64-demos.tar.gz"
DEMOS_x86_solaris="jdk-${MY_PV}-solaris-i586-demos.tar.Z"
DEMOS_x64_solaris="${DEMOS_x86_solaris} jdk-${MY_PV}-solaris-x64-demos.tar.Z"
DEMOS_sparc_solaris="jdk-${MY_PV}-solaris-sparc-demos.tar.Z"
DEMOS_sparc64_solaris="${DEMOS_sparc_solaris} jdk-${MY_PV}-solaris-sparcv9-demos.tar.Z"

JCE_FILE="jce_policy-6.zip"

DESCRIPTION="Oracle's Java SE Development Kit"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
for d in "${AT_AVAILABLE[@]}"; do
	SRC_URI+=" ${d}? ("
	SRC_URI+=" $(eval "echo \${$(echo AT_${d/-/_})}")"
	if has ${d} "${DEMOS_AVAILABLE[@]}"; then
		SRC_URI+=" examples? ( $(eval "echo \${$(echo DEMOS_${d/-/_})}") )"
	fi
	SRC_URI+=" )"
done
unset d
SRC_URI+=" jce? ( ${JCE_FILE} )"

LICENSE="Oracle-BCLA-JavaSE examples? ( BSD )"
SLOT="1.6"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+X alsa derby doc examples jce kernel_SunOS nsplugin pax_kernel selinux source"

RESTRICT="fetch strip"
QA_PREBUILT="*"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXt
		x11-libs/libXtst
	)
	alsa? ( media-libs/alsa-lib )
	doc? ( dev-java/java-sdk-docs:1.6.0 )
	selinux? ( sec-policy/selinux-java )
	!prefix? ( sys-libs/glibc )"
# scanelf won't create a PaX header, so depend on paxctl to avoid fallback
# marking. #427642
DEPEND="
	jce? ( app-arch/unzip )
	kernel_SunOS? ( app-arch/unzip )
	pax_kernel? ( sys-apps/paxctl )
	selinux? ( sec-policy/selinux-java )"

S="${WORKDIR}"/jdk${S_PV}

check_tarballs_available() {
	local uri=$1; shift
	local dl= unavailable=
	for dl in "${@}"; do
		[[ ! -f "${DISTDIR}/${dl}" ]] && unavailable+=" ${dl}"
	done

	if [[ -n "${unavailable}" ]]; then
		if [[ -z ${_check_tarballs_available_once} ]]; then
			einfo
			einfo "Due to Oracle no longer providing the distro-friendly DLJ bundles, the package"
			einfo "has become fetch restricted again. Alternatives are switching to"
			einfo "dev-java/icedtea-bin:6 or the source-based dev-java/icedtea:6"
			einfo
			einfo "Oracle requires you to download the needed files manually after"
			einfo "accepting their license through a javascript capable web browser."
			einfo
			_check_tarballs_available_once=1
		fi
		einfo "Download the following files:"
		for dl in ${unavailable}; do
			einfo "  ${dl}"
		done
		einfo "at '${uri}'"
		einfo "and move them to '${DISTDIR}'"
		einfo
	fi
}

pkg_nofetch() {
	local distfiles=( $(eval "echo \${$(echo AT_${ARCH/-/_})}") )
	if use examples && has ${ARCH} "${DEMOS_AVAILABLE[@]}"; then
		distfiles+=( $(eval "echo \${$(echo DEMOS_${ARCH/-/_})}") )
	fi
	check_tarballs_available "${JDK_URI}" "${distfiles[@]}"

	use jce && check_tarballs_available "${JCE_URI}" "${JCE_FILE}"
}

src_unpack() {
	AT=( $(eval "echo \${$(echo AT_${ARCH/-/_})}") )
	DEMOS=( $(eval "echo \${$(echo DEMOS_${ARCH/-/_})}") )

	if use kernel_SunOS; then
		for i in ${AT}; do
			rm -f "${S}"/jre/{LICENSE,README} "${S}"/LICENSE
			# don't die on unzip, it always "fails"
			unzip "${DISTDIR}"/${i}
		done
		for f in $(find "${S}" -name "*.pack") ; do
			"${S}"/bin/unpack200 ${f} ${f%.pack}.jar
			rm ${f}
		done
	else
		sh "${DISTDIR}"/${AT} -noregister || die "Failed to unpack"
	fi

	if has "${ARCH}" "${DEMOS_AVAILABLE[@]}" &&  use examples ; then
		unpack ${DEMOS}
		if use kernel_SunOS; then
			mv "${WORKDIR}"/SUNWj6dmo/reloc/jdk/instances/jdk1.6.0/{demo,sample} "${S}"/ || die
		fi
	fi

	if use jce; then
		unpack ${JCE_FILE}
		mv jce "${S}"/jre/lib/security/unlimited-jce || die
	fi
}

src_compile() {
	# This needs to be done before CDS - #215225
	java-vm_set-pax-markings "${S}"

	# see bug #207282
	einfo "Creating the Class Data Sharing archives"
	case ${ARCH} in
		ia64)
			bin/java -client -Xshare:dump || die
			;;
		x86)
			bin/java -client -Xshare:dump || die
			# limit heap size for large memory on x86 #405239
			# this is a workaround and shouldn't be needed.
			bin/java -server -Xmx64m -Xshare:dump || die
			;;
		*)
			bin/java -server -Xshare:dump || die
			;;
	esac
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest}"

	# We should not need the ancient plugin for Firefox 2 anymore, plus it has
	# writable executable segments
	if use x86; then
		rm -vf {,jre/}lib/i386/libjavaplugin_oji.so \
			{,jre/}lib/i386/libjavaplugin_nscp*.so
		rm -vrf jre/plugin/i386
	fi
	# Without nsplugin flag, also remove the new plugin
	local arch=${ARCH};
	use x86 && arch=i386;
	if ! use nsplugin; then
		rm -vf {,jre/}lib/${arch}/libnpjp2.so \
			{,jre/}lib/${arch}/libjavaplugin_jni.so
	fi

	dodoc COPYRIGHT
	dohtml README.html

	dodir "${dest}"
	cp -pPR bin include jre lib man "${ddest}" || die

	if use derby; then
		cp -pPR db "${ddest}" || die
	fi

	if use examples && has ${ARCH} "${DEMOS_AVAILABLE[@]}"; then
		cp -pPR demo sample "${ddest}" || die
	fi

	if use jce; then
		dodir "${dest}"/jre/lib/security/strong-jce
		mv "${ddest}"/jre/lib/security/US_export_policy.jar \
			"${ddest}"/jre/lib/security/strong-jce || die
		mv "${ddest}"/jre/lib/security/local_policy.jar \
			"${ddest}"/jre/lib/security/strong-jce || die
		dosym "${dest}"/jre/lib/security/unlimited-jce/US_export_policy.jar \
			"${dest}"/jre/lib/security/US_export_policy.jar
		dosym "${dest}"/jre/lib/security/unlimited-jce/local_policy.jar \
			"${dest}"/jre/lib/security/local_policy.jar
	fi

	if use nsplugin; then
		install_mozilla_plugin "${dest}"/jre/lib/${arch}/libnpjp2.so
	fi

	if use source; then
		cp src.zip "${ddest}" || die
	fi

	# Install desktop file for the Java Control Panel.
	# Using ${PN}-${SLOT} to prevent file collision with jre and or other slots.
	# make_desktop_entry can't be used as ${P} would end up in filename.
	newicon jre/lib/desktop/icons/hicolor/48x48/apps/sun-jcontrol.png \
		sun-jcontrol-${PN}-${SLOT}.png || die
	sed -e "s#Name=.*#Name=Java Control Panel for Oracle JDK ${SLOT} (sun-jdk)#" \
		-e "s#Exec=.*#Exec=/opt/${P}/jre/bin/jcontrol#" \
		-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}#" \
		-e "s#Application;##" \
		-e "/Encoding/d" \
		jre/lib/desktop/applications/sun_java.desktop \
		> "${T}"/jcontrol-${PN}-${SLOT}.desktop || die
	domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop

	# http://docs.oracle.com/javase/6/docs/technotes/guides/intl/fontconfig.html
	rm "${ddest}"/jre/lib/fontconfig.* || die
	cp "${FILESDIR}"/fontconfig.Gentoo.properties-r1 "${T}"/fontconfig.properties || die
	eprefixify "${T}"/fontconfig.properties
	insinto "${dest}"/jre/lib/
	doins "${T}"/fontconfig.properties

	# Remove empty dirs we might have copied
	find "${D}" -type d -empty -exec rmdir -v {} + || die

	set_java_env "${FILESDIR}/${VMHANDLE}.env-r1"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	elog "If you want Oracles JDK 7 'emerge oracle-jdk-bin' instead."
}
