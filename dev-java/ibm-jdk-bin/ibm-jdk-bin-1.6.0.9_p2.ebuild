# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit java-vm-2 versionator eutils

JDK_RELEASE=$(get_version_component_range 2-3)
JAVACOMM_RELEASE=$(get_version_component_range 3)
SERVICE_RELEASE=$(get_version_component_range 4)
SERVICE_RELEASE_LINK="${SERVICE_RELEASE}"

# versions ending with _pX translate to .X in distfile and fpX in SRC_URI
if [[ $(get_version_component_count) == 5 ]]; then
	FP_VERSION="$(get_version_component_range 5)"
	FP_VERSION="${FP_VERSION#p}"
	FP_WEB="-FP${FP_VERSION}"
	FP_LINK="fp${FP_VERSION}"
	TGZ_PV="${JDK_RELEASE}-${SERVICE_RELEASE}.${FP_VERSION}"
else
	FP_WEB=""
	FP_LINK=""
	TGZ_PV="${JDK_RELEASE}-${SERVICE_RELEASE}.0"
fi

#JAVACOMM_PV="3.${JAVACOMM_RELEASE}-${SERVICE_RELEASE}.0"
# looks like they don't bump javacomm in service releases anymore
JAVACOMM_PV_ORIG="3.${JAVACOMM_RELEASE}-0.0"
JAVACOMM_PV="${JDK_RELEASE}-${SERVICE_RELEASE}.0"

JDK_DIST_PREFIX="ibm-java-sdk-${TGZ_PV}-linux"
JAVACOMM_DIST_PREFIX="ibm-java-javacomm-${JAVACOMM_PV}-linux"
JAVACOMM_DIST_PREFIX_ORIG="ibm-java-javacomm-${JAVACOMM_PV_ORIG}-linux"

X86_JDK_DIST="${JDK_DIST_PREFIX}-i386.tgz"
X86_JAVACOMM_DIST="${JAVACOMM_DIST_PREFIX}-i386.tgz"
X86_JAVACOMM_DIST_ORIG="${JAVACOMM_DIST_PREFIX_ORIG}-i386.tgz"

AMD64_JDK_DIST="${JDK_DIST_PREFIX}-x86_64.tgz"
AMD64_JAVACOMM_DIST="${JAVACOMM_DIST_PREFIX}-x86_64.tgz"
AMD64_JAVACOMM_DIST_ORIG="${JAVACOMM_DIST_PREFIX_ORIG}-x86_64.tgz"

PPC_JDK_DIST="${JDK_DIST_PREFIX}-ppc.tgz"
PPC_JAVACOMM_DIST="${JAVACOMM_DIST_PREFIX}-ppc.tgz"
PPC_JAVACOMM_DIST_ORIG="${JAVACOMM_DIST_PREFIX_ORIG}-ppc.tgz"

PPC64_JDK_DIST="${JDK_DIST_PREFIX}-ppc64.tgz"
PPC64_JAVACOMM_DIST="${JAVACOMM_DIST_PREFIX}-ppc64.tgz"
PPC64_JAVACOMM_DIST_ORIG="${JAVACOMM_DIST_PREFIX_ORIG}-ppc64.tgz"

if use x86; then
	JDK_DIST=${X86_JDK_DIST}
	JAVACOMM_DIST=${X86_JAVACOMM_DIST}
	JAVACOMM_DIST_ORIG=${X86_JAVACOMM_DIST_ORIG}
	S="${WORKDIR}/ibm-java-i386-60"
	LINK_ARCH="intel"
elif use amd64; then
	JDK_DIST=${AMD64_JDK_DIST}
	JAVACOMM_DIST=${AMD64_JAVACOMM_DIST}
	JAVACOMM_DIST_ORIG=${AMD64_JAVACOMM_DIST_ORIG}
	S="${WORKDIR}/ibm-java-x86_64-60"
	LINK_ARCH="amd64"
elif use ppc; then
	JDK_DIST=${PPC_JDK_DIST}
	JAVACOMM_DIST=${PPC_JAVACOMM_DIST}
	JAVACOMM_DIST_ORIG=${PPC_JAVACOMM_DIST_ORIG}
	S="${WORKDIR}/ibm-java-ppc-60"
	LINK_ARCH="ipseries32"
elif use ppc64; then
	JDK_DIST=${PPC64_JDK_DIST}
	JAVACOMM_DIST=${PPC64_JAVACOMM_DIST}
	JAVACOMM_DIST_ORIG=${PPC64_JAVACOMM_DIST_ORIG}
	S="${WORKDIR}/ibm-java-ppc64-60"
	LINK_ARCH="ipseries64"
fi

DIRECT_DOWNLOAD="https://www14.software.ibm.com/webapp/iwm/web/preLogin.do?source=swg-sdk6&S_PKG=${LINK_ARCH}_6sr${SERVICE_RELEASE}${FP_LINK}&S_TACT=105AGX05&S_CMP=JDK"

SLOT="1.6"
DESCRIPTION="IBM Java SE Development Kit"
HOMEPAGE="http://www.ibm.com/developerworks/java/jdk/"
DOWNLOADPAGE="${HOMEPAGE}linux/download.html"
# bug #125178
ALT_DOWNLOADPAGE="${HOMEPAGE}linux/older_download.html"

SRC_URI="
	x86? ( ${X86_JDK_DIST} )
	amd64? ( ${AMD64_JDK_DIST} )
	ppc? ( ${PPC_JDK_DIST} )
	ppc64? ( ${PPC64_JDK_DIST} )
	javacomm? (
		x86? ( ${X86_JAVACOMM_DIST} )
		amd64? ( ${AMD64_JAVACOMM_DIST} )
		ppc? ( ${PPC_JAVACOMM_DIST} )
		ppc64? ( ${PPC64_JAVACOMM_DIST} )
	)"
LICENSE="IBM-J1.6"
KEYWORDS="-* amd64 ppc64 x86"
RESTRICT="fetch"
IUSE="X alsa doc examples javacomm nsplugin odbc selinux"

RDEPEND="
	ppc? ( =virtual/libstdc++-3.3 )
	ppc64? ( =virtual/libstdc++-3.3 )
	X? (
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXi
		x11-libs/libXp
		x11-libs/libXtst
		x11-libs/libX11
		x11-libs/libXt
	)
	alsa? ( media-libs/alsa-lib )
	doc? ( =dev-java/java-sdk-docs-1.6.0* )
	odbc? ( dev-db/unixODBC )
	selinux? ( sec-policy/selinux-java )"

DEPEND=""

QA_TEXTRELS_x86="opt/${P}/jre/lib/i386/libj9jvmti24.so
opt/${P}/jre/lib/i386/libj9vm24.so
opt/${P}/jre/lib/i386/libjclscar_24.so
opt/${P}/jre/lib/i386/motif21/libmawt.so
opt/${P}/jre/lib/i386/libj9thr24.so
opt/${P}/jre/lib/i386/libj9jit24.so
opt/${P}/jre/lib/i386/libj9dbg24.so
opt/${P}/jre/lib/i386/libj9gc24.so"

QA_EXECSTACK_x86="opt/${P}/jre/bin/classic/libjvm.so
opt/${P}/jre/lib/i386/j9vm/libjvm.so
opt/${P}/jre/lib/i386/libj9jvmti24.so
opt/${P}/jre/lib/i386/libj9hookable24.so
opt/${P}/jre/lib/i386/libj9vm24.so
opt/${P}/jre/lib/i386/libjclscar_24.so
opt/${P}/jre/lib/i386/libj9thr24.so
opt/${P}/jre/lib/i386/libj9dmp24.so
opt/${P}/jre/lib/i386/libj9prt24.so
opt/${P}/jre/lib/i386/libj9jit24.so
opt/${P}/jre/lib/i386/libiverel24.so
opt/${P}/jre/lib/i386/libj9trc24.so
opt/${P}/jre/lib/i386/libj9dbg24.so
opt/${P}/jre/lib/i386/libj9shr24.so
opt/${P}/jre/lib/i386/libj9gc24.so
opt/${P}/jre/lib/i386/libj9bcv24.so
opt/${P}/jre/lib/i386/classic/libjvm.so"

QA_EXECSTACK_amd64="opt/${P}/jre/lib/amd64/default/libjvm.so
opt/${P}/jre/lib/amd64/default/libj9jvmti24.so
opt/${P}/jre/lib/amd64/default/libj9hookable24.so
opt/${P}/jre/lib/amd64/default/libj9vm24.so
opt/${P}/jre/lib/amd64/default/libjclscar_24.so
opt/${P}/jre/lib/amd64/default/libj9jpi24.so
opt/${P}/jre/lib/amd64/default/libj9thr24.so
opt/${P}/jre/lib/amd64/default/libj9dmp24.so
opt/${P}/jre/lib/amd64/default/libj9prt24.so
opt/${P}/jre/lib/amd64/default/libj9jit24.so
opt/${P}/jre/lib/amd64/default/libiverel24.so
opt/${P}/jre/lib/amd64/default/libj9trc24.so
opt/${P}/jre/lib/amd64/default/libj9dbg24.so
opt/${P}/jre/lib/amd64/default/libj9shr24.so
opt/${P}/jre/lib/amd64/default/libj9gc24.so
opt/${P}/jre/lib/amd64/default/libj9bcv24.so
opt/${P}/jre/lib/amd64/default/libj9ute24.so
opt/${P}/jre/lib/amd64/compressedrefs/libjvm.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9jvmti24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9hookable24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9vm24.so
opt/${P}/jre/lib/amd64/compressedrefs/libjclscar_24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9jpi24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9thr24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9dmp24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9prt24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9jit24.so
opt/${P}/jre/lib/amd64/compressedrefs/libiverel24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9trc24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9dbg24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9shr24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9gc24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9bcv24.so
opt/${P}/jre/lib/amd64/compressedrefs/libj9ute24.so"

pkg_nofetch() {
	einfo "Due to license restrictions, we cannot redistribute or fetch the distfiles"
	einfo "Please visit: ${DOWNLOADPAGE}"

	einfo "Under Java SE 6, download SR${SERVICE_RELEASE}${FP_WEB} for your arch:"
	einfo "${JDK_DIST}"
	if use javacomm ; then
		einfo "Also download ${JAVACOMM_DIST_ORIG}"
		ewarn "and save it as ${JAVACOMM_DIST}"
		ewarn "Renaming is needed because javacomm changes content without changing filename."
	fi

	einfo "You can also use a direct link to your arch download page:"
	einfo "${DIRECT_DOWNLOAD}"
	einfo "Place the file(s) in: ${DISTDIR}"
	einfo "Then restart emerge: 'emerge --resume'"

	einfo "Note: if SR${SERVICE_RELEASE}${FP_WEB} is not available at ${DOWNLOADPAGE}"
	einfo "it may have been moved to ${ALT_DOWNLOADPAGE}. Lately that page"
	einfo "isn't updated, but the files should still available through the"
	einfo "direct link to arch download page. If it doesn't work, file a bug."
}

src_unpack() {
	unpack ${JDK_DIST}
	if use javacomm; then
		mkdir "${WORKDIR}/javacomm/" || die
		cd "${WORKDIR}/javacomm/"
		unpack ${JAVACOMM_DIST}
	fi
	cd "${S}"

	# bug #126105
	epatch "${FILESDIR}/${PN}-jawt.h.patch"
}

src_compile() { :; }

src_install() {
	# Copy all the files to the designated directory
	dodir /opt/${P}
	cp -pR "${S}"/{bin,jre,lib,include,src.zip} "${D}/opt/${P}/" || die

	if use examples; then
		cp -pPR "${S}"/demo "${D}"/opt/${P}/ || die
	fi
	if use javacomm; then
		chmod -x "${WORKDIR}"/javacomm/*/jar/*.jar "${WORKDIR}"/javacomm/*/lib/*.properties || die
		cp -pR "${WORKDIR}"/javacomm/*/jar/*.jar "${D}"/opt/${P}/jre/lib/ext/ || die
		cp -pR "${WORKDIR}"/javacomm/*/lib/*.properties "${D}"/opt/${P}/jre/lib/ || die
		cp -pR "${WORKDIR}"/javacomm/*/lib/*.so "${D}"/opt/${P}/jre/lib/$(get_system_arch)/ || die
		if use examples; then
			cp -pPR "${WORKDIR}"/javacomm/*/examples "${D}"/opt/${P}/ || die
		fi
	fi

	if use x86 || use ppc; then
		if use nsplugin; then
			local plugin="/opt/${P}/jre/plugin/$(get_system_arch)/ns7/libjavaplugin_oji.so"
			install_mozilla_plugin "${plugin}"
		fi
	fi

	local desktop_in="${D}/opt/${P}/jre/plugin/desktop/sun_java.desktop"
	if [[ -f "${desktop_in}" ]]; then
		local desktop_out="${T}/ibm_jdk-${SLOT}.desktop"
		# install control panel for Gnome/KDE
		# The jre also installs these so make sure that they do not have the same
		# Name
		sed -e "s/\(Name=\)Java/\1 Java Control Panel for IBM JDK ${SLOT}/" \
			-e "s#Exec=.*#Exec=/opt/${P}/jre/bin/jcontrol#" \
			-e "s#Icon=.*#Icon=/opt/${P}/jre/plugin/desktop/sun_java.png#" \
			"${desktop_in}" > \
			"${desktop_out}" || die

		domenu "${desktop_out}" || die
	fi

	dohtml -a html,htm,HTML -r docs || die
	dodoc "${S}"/{copyright,notices.txt,readmefirst.lnx.txt} || die

	set_java_env

	# a workaround to fix the BOOTCLASSPATH in our env file
	# this is not optimal, using -Xcompressedrefs would probably make it
	# expect the compressedrefs version...
	if use amd64; then
		sed -i -e "s|vm.jar|amd64/default/jclSC160/vm.jar|g" "${D}${JAVA_VM_CONFIG_DIR}/${VMHANDLE}" || die "sed failed"
	fi
	if use ppc64; then
		sed -i -e "s|vm.jar|ppc64/default/jclSC160/vm.jar|g" "${D}${JAVA_VM_CONFIG_DIR}/${VMHANDLE}" || die "sed failed"
	fi

	java-vm_revdep-mask

	# bug #321695
	dodir /etc/sandbox.d
	echo 'SANDBOX_PREDICT="/proc/self/coredump_filter"' > "${D}/etc/sandbox.d/20${VMHANDLE}"
}
