# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/tsm/tsm-6.2.2.0-r2.ebuild,v 1.2 2013/01/01 19:10:12 ulm Exp $

EAPI=5

inherit versionator multilib eutils rpm pax-utils user

DESCRIPTION="Tivoli Storage Manager (TSM) Backup/Archive (B/A) Client and API"
HOMEPAGE="http://www.tivoli.com/"

MY_PV_MAJOR=$(get_major_version)
MY_PV_MINOR=$(get_version_component_range 2)
MY_PV_TINY=$(get_version_component_range 3)

MY_PV_NODOTS="${MY_PV_MAJOR}${MY_PV_MINOR}${MY_PV_TINY}"
MY_PVR_ALLDOTS=${PV}

BASE_URI="ftp://ftp.software.ibm.com/storage/tivoli-storage-management/maintenance/client/v${MY_PV_MAJOR}r${MY_PV_MINOR}/Linux/LinuxX86/v${MY_PV_NODOTS}/"
SRC_TAR="${MY_PVR_ALLDOTS}-TIV-TSMBAC-LinuxX86.tar"
SRC_URI="${BASE_URI}${SRC_TAR}"

RESTRICT="strip" # Breaks libPiIMG.ss and libPiSNAP.so
LICENSE="Apache-1.1 Apache-2.0 JDOM BSD-2 CC-PD Boost-1.0 MIT CPL-1.0 HPND Exolab
	dom4j EPL-1.0 FTL icu unicode IBM Info-ZIP LGPL-2 LGPL-2.1 openafs-krb5-a
	ZLIB MPL-1.0 MPL-1.1 NPL-1.1 openssl OPENLDAP RSA public-domain W3C
	|| ( BSD GPL-2+ ) gSOAP libpng tsm"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="hsm"

QA_PREBUILT="*"

MY_LANGS="cs:CS_CZ de:DE_DE es:ES_ES fr:FR_FR hu:HU_HU it:IT_IT
	ja:JA_JP ko:KO_KR pl:PL_PL pt:PT_BR ru:RU_RU zh:ZH_CN zh_TW:ZH_TW"
MY_LANG_PV="$(get_version_component_range 1-3)-"
for lang in ${MY_LANGS}; do
	IUSE="${IUSE} linguas_${lang%:*}"
	SRC_URI="${SRC_URI} linguas_${lang%:*}? ( ${BASE_URI}TIVsm-msg.${lang#*:}.i386.rpm -> ${MY_LANG_PV}TIVsm-msg.${lang#*:}.i386.rpm )"
done
unset lang

DEPEND=""
RDEPEND="sys-libs/libstdc++-v3"

S="${WORKDIR}"

pkg_setup() {
	enewgroup tsm
}

src_unpack() {
	local rpm rpms lang
	unpack ${SRC_TAR}

	for rpm in *.rpm; do
		case ${rpm} in
			gsk*64-*|*API64*)
				use amd64 && rpms="${rpms} ./${rpm}"
				;;
			*HSM*)
				use hsm && rpms="${rpms} ./${rpm}"
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
	chmod -R u+w "${S}"
}

src_prepare() {
	# Avoid unnecessary dependency on ksh
	sed -i 's:^#!/usr/bin/ksh:#!/bin/bash:' \
		opt/tivoli/tsm/client/ba/bin/dsmj || die
}

src_install() {
	cp -a opt "${D}"
	cp -a usr "${D}"

	# The RPM files contain postinstall scripts which can be extracted
	# e.g. using https://bugs.gentoo.org/attachment.cgi?id=234663 .
	# Below we try to mimic the behaviour of these scripts.
	# We don't deal with SELinux compliance (yet), though.
	local RPM_INSTALL_PREFIX CLIENTDIR TIVINV_DIR TIVINVFILE i
	RPM_INSTALL_PREFIX=/opt
	CLIENTDIR=$RPM_INSTALL_PREFIX/tivoli/tsm/client

	# We don't bother setting timestamps to build dates.
	# But we should delete the corresponding files.
	rm -f "${D}"$CLIENTDIR/api/bin*/.buildDate
	rm -f "${D}"$CLIENTDIR/ba/bin*/.buildDate
	rm -f "${D}"$CLIENTDIR/lang/.buildDate

	# Create links for messages; this is spread over several postin scripts.
	for i in $(cd "${D}"/${CLIENTDIR}/lang; ls -1d ??_??); do
		dosym ../../lang/${i} $CLIENTDIR/ba/bin/${i}
		dosym ../../lang/${i} $CLIENTDIR/api/bin/${i}
		use amd64 && dosym ../../lang/${i} $CLIENTDIR/api/bin64/${i}
	done

	# Mimic TIVsm-API and -API64 postinstall script
	for i in libgpfs.so libdmapi.so; do
		dosym ../..$CLIENTDIR/api/bin/${i} /usr/lib
	done
	dosym ../..$CLIENTDIR/ba/bin/libzephyr.so /usr/lib/libTSMNetAppzephyr.so

	# Mimic TIVsm-BA postinstall script
	for i in /etc/adsm{,/SpaceMan,/config,/status}; do
		keepdir ${i}
		fowners bin:bin ${i}
		fperms 2775 ${i}
	done
	TIVINV_DIR="/opt/tivoli/tsm/tivinv"
	TIVINVFILE="TIVTSMBAC0602.SYS2"
	dodir $TIVINV_DIR
	echo "                                                 " \
		> "${D}$TIVINV_DIR/$TIVINVFILE"
	fperms 555 $TIVINV_DIR/$TIVINVFILE

	# Haven't ported the TIVsm-HSM postinstall script (yet).
	if use hsm; then
		ewarn "This ebuild doesn't mimic the HSM postinstall script."
	fi

	# The gscrypt{32|64} postinstall script only deals with s390[x] SELinux.

	# Mimic gskssl32 postinstall script
	for i in acmeidup valn km cms p11 dbfl kicc ssl sys ldap drld iccs; do
		dosym ../local/ibm/gsk8/lib/libgsk8${i}.so /usr/lib/libgsk8${i}.so
	done
	for i in capicmd ver; do
		dosym ../local/ibm/gsk8/bin/gsk8${i} /usr/bin/${i}
	done

	# Mimic gskssl64 postinstall script
	if use amd64; then
		for i in sys p11 km ssl drld kicc ldap cms acmeidup valn dbfl iccs; do
			dosym ../local/ibm/gsk8_64/lib64/libgsk8${i}_64.so \
				/usr/lib64/libgsk8${i}_64.so
		done
		for i in capicmd ver; do
			dosym ../local/ibm/gsk8_64/bin/gsk8${i}_64 /usr/bin/${i}_64
		done
	fi

	# Done with the postinstall scripts as the RPMs contain them.
	# Now on to some more Gentoo-specific installation.

	use amd64 && mv "${D}usr/lib" "${D}usr/lib32"

	fowners -R :tsm /opt/tivoli
	fperms -R g+rX,o-rX /opt/tivoli # Allow only tsm group users to access TSM tools
	fperms 4710 /opt/tivoli/tsm/client/ba/bin/dsmtca

	keepdir /var/log/tsm
	fowners :tsm /var/log/tsm
	fperms 2770 /var/log/tsm
	insinto /etc/logrotate.d
	newins "${FILESDIR}/tsm.logrotate" tsm

	keepdir /etc/tivoli

	cp -a "${S}/opt/tivoli/tsm/client/ba/bin/dsm.sys.smp" "${D}/etc/tivoli/dsm.sys"
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

	elog
	elog "Note that you have to be either root or member of the group tsm to be able to use the"
	elog "Tivoli Storage Manager client."
	elog

}

pkg_postinst() {
	local i
	for i in /var/log/tsm/dsm{error,sched,j,webcl}.log; do
		if [[ ! -e $i ]]; then
			touch $i
			chown :tsm $i
			chmod 0660 $i
		fi
	done
}

pkg_postinst() {
	pax-mark psme /opt/tivoli/tsm/client/ba/bin/dsmc
	# most likely some of the other executables (e.g. dsm) need this as well, but I
	# cannot test it at the moment. - dilfridge
}
