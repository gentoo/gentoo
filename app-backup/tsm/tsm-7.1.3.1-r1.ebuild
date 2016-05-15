# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator multilib eutils readme.gentoo rpm systemd user pax-utils

DESCRIPTION="Tivoli Storage Manager (TSM) Backup/Archive (B/A) Client and API"
HOMEPAGE="http://www.tivoli.com/"

MY_PV_MAJOR=$(get_major_version)
MY_PV_MINOR=$(get_version_component_range 2)
MY_PV_TINY=$(get_version_component_range 3)
MY_PV_PATCH=$(get_version_component_range 4)

MY_PV_NODOTS="${MY_PV_MAJOR}${MY_PV_MINOR}${MY_PV_TINY}"
MY_PVR_ALLDOTS=${PV}

if [[ ${MY_PV_PATCH} == 0 ]]; then
	MY_RELEASE_PATH=maintenance
else
	MY_RELEASE_PATH=patches
fi
BASE_URI="ftp://ftp.software.ibm.com/storage/tivoli-storage-management/"
BASE_URI+="${MY_RELEASE_PATH}/client/v${MY_PV_MAJOR}r${MY_PV_MINOR}/"
BASE_URI+="Linux/LinuxX86/BA/v${MY_PV_NODOTS}/"
SRC_TAR="${MY_PVR_ALLDOTS}-TIV-TSMBAC-LinuxX86.tar"
SRC_URI="${BASE_URI}${SRC_TAR}"

RESTRICT="strip" # Breaks libPiIMG.so and libPiSNAP.so
LICENSE="Apache-1.1 Apache-2.0 JDOM BSD-2 CC-PD Boost-1.0 MIT CPL-1.0 HPND Exolab
	dom4j EPL-1.0 FTL icu unicode IBM Info-ZIP LGPL-2 LGPL-2.1 openafs-krb5-a
	ZLIB MPL-1.0 MPL-1.1 NPL-1.1 openssl OPENLDAP RSA public-domain W3C
	|| ( BSD GPL-2+ ) gSOAP libpng tsm"

SLOT="0"
KEYWORDS="~amd64 -*"
IUSE="acl java +tsm_cit +tsm_hw"
QA_PREBUILT="*"

# not available (yet?)
#MY_LANGS="cs:CS_CZ de:DE_DE es:ES_ES fr:FR_FR hu:HU_HU it:IT_IT
#	ja:JA_JP ko:KO_KR pl:PL_PL pt:PT_BR ru:RU_RU zh:ZH_CN zh_TW:ZH_TW"
MY_LANG_PV="${MY_PVR_ALLDOTS}-"
for lang in ${MY_LANGS}; do
	IUSE="${IUSE} linguas_${lang%:*}"
	SRC_URI="${SRC_URI} linguas_${lang%:*}? ( \
${BASE_URI}TIVsm-msg.${lang#*:}.x86_64.rpm -> \
${MY_LANG_PV}TIVsm-msg.${lang#*:}.x86_64.rpm )"
done
unset lang

DEPEND=""
RDEPEND="
	dev-libs/expat
	dev-libs/libxml2
	=sys-fs/fuse-2*
	acl? ( sys-apps/acl )
	java? ( virtual/jre:1.7 )
"

S="${WORKDIR}"

pkg_setup() {
	enewgroup tsm
	DOC_CONTENTS="
		Note that you have to be either root or member of the group tsm to
		be able to use the Tivoli Storage Manager client."
}

src_unpack() {
	local rpm rpms lang
	unpack ${SRC_TAR}

	for rpm in *.rpm; do
		case ${rpm} in
			TIVsm-APIcit.*|TIVsm-BAcit.*)
				use tsm_cit && rpms="${rpms} ./${rpm}"
				;;
			TIVsm-BAhdw.*)
				use tsm_hw && rpms="${rpms} ./${rpm}"
				;;
			TIVsm-JBB.*|*-filepath-*)
				# "journal based backup" for all filesystems
				# requires a kernel module.
				# "Linux Filepath source code" available
				# by request from vendor
				;;
			*)
				rpms="${rpms} ./${rpm}"
				;;
		esac
	done
	for rpm in ${A}; do
		case ${rpm} in
			*.rpm)
				rpms="${rpms} ${rpm}"
				;;
		esac
	done

	rpm_unpack ${rpms}

	# Avoid strange error messages caused by read-only files
	chmod -R u+w "${S}" || die
}

src_prepare() {
	# Avoid unnecessary dependency on ksh
	sed -i 's:^#!/usr/bin/ksh:#!/bin/bash:' \
		opt/tivoli/tsm/client/ba/bin/dsmj || die
}

src_install() {
	cp -a opt "${D}" || die
	cp -a usr "${D}" || die

	# The RPM files contain postinstall scripts which can be extracted
	# e.g. using https://bugs.gentoo.org/attachment.cgi?id=234663 .
	# Below we try to mimic the behaviour of these scripts.
	# We don't deal with SELinux compliance (yet), though.
	local RPM_INSTALL_PREFIX CLIENTDIR i
	RPM_INSTALL_PREFIX=/opt
	CLIENTDIR=$RPM_INSTALL_PREFIX/tivoli/tsm/client

	# We don't bother setting timestamps to build dates.
	# But we should delete the corresponding files.
	rm -f "${D}"$CLIENTDIR/api/bin*/.buildDate || die
	rm -f "${D}"$CLIENTDIR/ba/bin*/.buildDate || die
	rm -f "${D}"$CLIENTDIR/lang/.buildDate || die

	# Create links for messages; this is spread over several postin scripts.
	for i in $(cd "${D}"${CLIENTDIR}/lang; ls -1d ??_??); do
		dosym ../../lang/${i} $CLIENTDIR/ba/bin/${i}
		dosym ../../lang/${i} $CLIENTDIR/api/bin64/${i}
	done

	# Mimic TIVsm-API64 postinstall script
	for i in libgpfs.so libdmapi.so; do
		dosym ../..$CLIENTDIR/api/bin64/${i} /usr/lib64/${i}
	done

	# The TIVsm-BA postinstall script only does messages and ancient upgrades

	# The gscrypt64 postinstall script only deals with s390[x] SELinux
	# and the symlink for the iccs library which we handle in the loop below.

	# Move stuff from /usr/local to /opt, #452332
	mv "${D}"/usr/local/ibm "${D}"/opt/ || die
	rmdir "${D}"/usr/local || die

	# Mimic gskssl64 postinstall script
	for i in sys p11 km ssl drld kicc ldap cms acmeidup valn dbfl iccs; do
		dosym ../../opt/ibm/gsk8_64/lib64/libgsk8${i}_64.so \
			/usr/lib64/libgsk8${i}_64.so
	done
	for i in capicmd ver; do
		dosym ../../opt/ibm/gsk8_64/bin/gsk8${i}_64 /usr/bin/gsk${i}_64
	done

	# Done with the postinstall scripts as the RPMs contain them.
	# Now on to some more Gentoo-specific installation.

	[[ -d "${D}usr/lib" ]] && die "Using 32bit lib dir in 64bit only system"

	# Avoid "QA Notice: Found an absolute symlink in a library directory"
	local target
	find "${D}"usr/lib* -lname '/*' | while read i; do
		target=$(readlink "${i}")
		rm -v "${i}" || die
		dosym "../..${target}" "${i#${D}}"
	done

	# Install symlinks for sonames of libraries, bug #416503
	dosym libvixMntapi.so.1.1.0 $CLIENTDIR/ba/bin/libvixMntapi.so.1
	dosym libvixDiskLibVim.so.5.5.0 $CLIENTDIR/ba/bin/libvixDiskLibVim.so.5
	dosym libvixDiskLib.so.5.5.0 $CLIENTDIR/ba/bin/libvixDiskLib.so.5

	fowners :tsm /opt/tivoli/tsm/client/ba/bin/dsmtca
	fperms 4710 /opt/tivoli/tsm/client/ba/bin/dsmtca

	keepdir /var/log/tsm
	insinto /etc/logrotate.d
	newins "${FILESDIR}/tsm.logrotate" tsm

	keepdir /etc/tivoli

	cp -a "${S}/opt/tivoli/tsm/client/ba/bin/dsm.sys.smp" "${D}/etc/tivoli/dsm.sys" || die
	echo '	 PasswordDir "/etc/tivoli/"' >> ${D}/etc/tivoli/dsm.sys
	echo '	 PasswordAccess generate' >> ${D}/etc/tivoli/dsm.sys

	# Added the hostname to be more friendly, the admin will need to edit this file anyway
	echo '	 NodeName' `hostname` >> ${D}/etc/tivoli/dsm.sys
	echo '	 ErrorLogName "/var/log/tsm/dsmerror.log"' >> ${D}/etc/tivoli/dsm.sys
	echo '	 SchedLogName "/var/log/tsm/dsmsched.log"' >> ${D}/etc/tivoli/dsm.sys
	dosym ../../../../../../etc/tivoli/dsm.sys /opt/tivoli/tsm/client/ba/bin/dsm.sys

	cp -a "${S}/opt/tivoli/tsm/client/ba/bin/dsm.opt.smp" "${D}/etc/tivoli/dsm.opt"
	dosym ../../../../../../etc/tivoli/dsm.opt /opt/tivoli/tsm/client/ba/bin/dsm.opt

	# Setup the env
	dodir /etc/env.d
	ENV_FILE="${D}/etc/env.d/80tivoli"
	echo 'DSM_CONFIG="/etc/tivoli/dsm.opt"' >> ${ENV_FILE}
	echo 'DSM_DIR="/opt/tivoli/tsm/client/ba/bin"' >> ${ENV_FILE}
	echo 'DSM_LOG="/var/log/tsm"' >> ${ENV_FILE}
	echo 'ROOTPATH="/opt/tivoli/tsm/client/ba/bin"' >> ${ENV_FILE}

	newconfd "${FILESDIR}/dsmc.conf.d" dsmc
	newinitd "${FILESDIR}/dsmc.init.d" dsmc
	newinitd "${FILESDIR}/dsmcad.init.d-r1" dsmcad

	# Need this for hardened, otherwise a cryptic "connection to server lost" message appears
	pax-mark -m "${D}/opt/tivoli/tsm/client/ba/bin/dsmc"

	systemd_dounit "${FILESDIR}/dsmc.service"
	systemd_dounit "${FILESDIR}/dsmcad.service"

	readme.gentoo_create_doc
}

pkg_postinst() {
	local i dirs
	for i in /var/log/tsm/dsm{error,sched,j,webcl}.log; do
		if [[ ! -e $i ]]; then
			touch $i || die
			chown :tsm $i || die
			chmod 0660 $i || die
		fi
	done

	# Bug #375041: the log directory itself should not be world writable.
	# Have to do this in postinst due to bug #141619
	chown root:tsm /var/log/tsm || die
	chmod 0750 /var/log/tsm || die

	# Bug 508052: directories used to be too restrictive, have to widen perms.
	dirs=( /opt/tivoli $(find /opt/tivoli/tsm -type d) )
	chown root:root "${dirs[@]}" || die
	chmod 0755 "${dirs[@]}" || die

	readme.gentoo_print_elog
}
