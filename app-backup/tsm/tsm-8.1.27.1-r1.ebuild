# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODULES_OPTIONAL_IUSE=journal
MODULES_KERNEL_MAX=6.1
inherit desktop linux-mod-r1 rpm toolchain-funcs pax-utils xdg

DESCRIPTION="IBM Storage Protect (former Tivoli Storage Manager) Backup/Archive Client, API"
HOMEPAGE="https://www.ibm.com/products/storage-protect"

BASE_URI="https://public.dhe.ibm.com/storage/tivoli-storage-management/"
if [[ $(ver_cut 4) == 0 ]]; then
	BASE_URI+="maintenance/client/v$(ver_cut 1)r$(ver_cut 2)/Linux/"
else
	BASE_URI+="patches/client/v$(ver_cut 1)r$(ver_cut 2)/Linux/"
fi

SRC_URI="
	amd64? (
		!gpfs? ( ${BASE_URI}LinuxX86/BA/v$(ver_rs 1-3 '' $(ver_cut 1-3))/${PV}-TIV-TSMBAC-LinuxX86.tar )
		gpfs? ( ${BASE_URI}LinuxX86/HSMGPFS/v$(ver_rs 1-3 '' $(ver_cut 1-3))/${PV}-TIV-TSMHSM-LinuxX86GPFS.tar )
	)
	ppc64? (
		!gpfs? (
			${BASE_URI}LinuxPPC/v$(ver_rs 1-3 '' $(ver_cut 1-3))/${PV}-TIV-TSMBAC-LinuxPPC.tar
			${BASE_URI}LinuxPLE/BA/v$(ver_rs 1-3 '' $(ver_cut 1-3))/${PV}-TIV-TSMBAC-LinuxPLE.tar
		)
		gpfs? ( ${BASE_URI}LinuxPLE/HSMGPFS/v$(ver_rs 1-3 '' $(ver_cut 1-3))/${PV}-TIV-TSMHSM-LinuxPLEGPFS.tar )
	)
	s390? ( ${BASE_URI}LinuxzSeries/BA/v$(ver_rs 1-3 '' $(ver_cut 1-3))/${PV}-TIV-TSMBAC-LinuxS390.tar )
"
S="${WORKDIR}"

LICENSE="
	Apache-1.1 Apache-2.0 JDOM BSD-2 CC-PD Boost-1.0 MIT CPL-1.0 HPND
	Exolab dom4j EPL-1.0 FTL icu unicode IBM Info-ZIP LGPL-2 LGPL-2.1
	openafs-krb5-a ZLIB MPL-1.0 MPL-1.1 NPL-1.1 openssl OPENLDAP RSA
	public-domain W3C gSOAP libpng tsm || ( BSD GPL-2+ )
"

SLOT="0"
KEYWORDS="~amd64" # ppc64 s390 -*

IUSE="gpfs gui"
# GPFS is not supported for journal-based backups on Linux
REQUIRED_USE="journal? ( !gpfs )"

RESTRICT="strip bindist mirror" # Breaks libPiIMG.so and libPiSNAP.so
QA_PREBUILT="/opt/*"
PLOCALE_BACKUP="en_US"
PLOCALES="
	cs_CZ de_DE en_US es_ES fr_FR hu_HU it_IT ja_JP ko_KR pl_PL pt_BR
	ru_RU zh_CN zh_TW
"

MY_LANGS="
	cs:CS_CZ de:DE_DE es:ES_ES fr:FR_FR hu:HU_HU it:IT_IT ja:JA_JP
	ko:KO_KR pl:PL_PL pt-BR:PT_BR ru:RU_RU zh-CN:ZH_CN zh-TW:ZH_TW
"
for lang in ${MY_LANGS}; do
	IUSE+=" l10n_${lang%:*}"
done

BDEPEND="
	app-arch/xz-utils[extra-filters(+)]
	gui? ( media-gfx/imagemagick[png] )
"
DEPEND="
	acct-group/tsm
"
RDEPEND="
	acct-group/tsm
	dev-libs/expat
	dev-libs/json-c:0/5.1
	>=dev-libs/openssl-3.3.0:0/3
	dev-libs/libxml2:2
	net-misc/curl[openssl]
	sys-apps/acl
	sys-fs/fuse:0
	virtual/zlib:0/1
	|| (
		sys-libs/libxcrypt:0/1[compat]
		sys-libs/glibc:2.2[crypt(-)]
	)
	gpfs? ( || (
		app-shells/ksh
		app-shells/loksh
	) )
	gui? (
		media-libs/alsa-lib
		virtual/jre
		x11-libs/libXft
	)
"

src_unpack() {
	if use amd64; then
		if use gpfs; then
			unpack "${PV}-TIV-TSMHSM-LinuxX86GPFS.tar"
		else
			unpack "${PV}-TIV-TSMBAC-LinuxX86.tar"
		fi
	elif use ppc64; then
		if [[ $(tc-endian) == big ]]; then
			if use gpfs; then
				die "GPFS not supported on big endian"
			else
				unpack "${PV}-TIV-TSMBAC-LinuxPPC.tar"
			fi
		else
			if use gpfs; then
				unpack "${PV}-TIV-TSMHSM-LinuxPLEGPFS.tar"
			else
				unpack "${PV}-TIV-TSMBAC-LinuxPLE.tar"
			fi
		fi
	elif use s390; then
		if use gpfs; then
			die "GPFS not supported on s390"
		else
			unpack "${PV}-TIV-TSMBAC-LinuxS390.tar"
		fi
	else
		die "Unsupported architecture"
	fi

	if ! use gui; then
		rm -f TIVsm-WEBGUI.*.rpm || die
	fi

	if ! use journal; then
		rm -f TIVsm-JBB.*.rpm || die
	fi

	mkdir rpms_unpacked || die
	pushd rpms_unpacked >/dev/null || die
	rpmunpack "${S}/"*.rpm
	popd >/dev/null || die

	use journal && unpack "${S}/TIVsm-filepath-source.tar.gz"
}

src_prepare() {
	default
	local lang
	for lang in ${MY_LANGS}; do
		if ! use l10n_${lang%:*}; then
			find -type d -name "${lang#*:}" -exec rm -r {} + || die
		fi
	done
}

src_compile() {
	local modlist=( filepath=:jbb_gpl )
	local modargs=(
		KDIR="${KV_OUT_DIR}" RELNUM=${PV}
		# The usage of arch is non-standard here
		$(usev amd64 ARCH=x86_64)
		$(usev ppc64 ARCH=ppc64)
	)
	linux-mod-r1_src_compile
}

src_install() {
	local i
	for i in rpms_unpacked/*; do
		rsync -a "${i}/"* "${ED}" || die
	done

	# Don't bundle java
	if [[ -e "${ED}/opt/tivoli/tsm/tdpvmware/common/jre" ]]; then
		rm -r "${ED}/opt/tivoli/tsm/tdpvmware/common/jre" || die
	fi

	# The RPM files contain postinstall scripts which can be extracted
	# e.g. using https://bugs.gentoo.org/attachment.cgi?id=234663 .
	# Below we try to mimic the behaviour of these scripts.
	# We don't deal with SELinux compliance (yet), though.

	# Mimic TIVsm-API64 postinstall script
	for i in "${ED}/opt/tivoli/tsm/client/api/bin64/"*.so; do
		dosym "../../opt/tivoli/tsm/client/api/bin64/$(basename "${i}")" \
			"/usr/$(get_libdir)/$(basename "${i}")"
	done

	# The TIVsm-BA postinstall script only does messages and ancient upgrades

	# The gscrypt64 postinstall script only deals with s390[x] SELinux
	# and the symlink for the iccs library which we handle in the loop below.

	# Move stuff from /usr/local to /opt, #452332
	mv "${ED}/usr/local/ibm" "${ED}/opt/" || die
	rmdir "${ED}/usr/local" || die

	# Mimic gskssl64 postinstall script
	for i in "${ED}/opt/ibm/gsk8_64/lib64/"*.so; do
		dosym "../../opt/ibm/gsk8_64/lib64/$(basename "${i}")" \
			"/usr/$(get_libdir)/$(basename "${i}")"
	done
	for i in "${ED}/opt/ibm/gsk8_64/bin/"*; do
		dosym "../../opt/ibm/gsk8_64/bin/$(basename "${i}")" \
			"/usr/bin/$(basename "${i//8/}")"
	done

	# Done with the postinstall scripts as the RPMs contain them.
	# Now on to some more Gentoo-specific installation.

	rm -rf "${ED}/usr/lib/.build-id" &> /dev/null
	[[ -d "${ED}/usr/lib" ]] && rmdir "${ED}/usr/lib" || die "Using 32bit lib dir in 64bit only system"

	# Avoid "QA Notice: Found an absolute symlink in a library directory"
	local target
	find "${ED}"/usr/lib* -lname '/*' | while read i; do
		target=$(readlink "${i}")
		rm -v "${i}" || die
		dosym "../..${target}" "${i#${ED}/}"
	done

	keepdir /var/log/tsm
	insinto /etc/logrotate.d
	newins "${FILESDIR}/tsm.logrotate" tsm

	keepdir /etc/tivoli

	cp -a "${ED}/opt/tivoli/tsm/client/ba/bin/dsm.sys.smp" "${ED}/etc/tivoli/dsm.sys" || die
	echo '	 PasswordDir "/etc/tivoli/"' >> "${ED}/etc/tivoli/dsm.sys"
	echo '	 PasswordAccess generate' >> "${ED}/etc/tivoli/dsm.sys"

	# Added the hostname to be more friendly, the admin will need to edit this file anyway
	echo '	 NodeName' $(hostname) >> "${ED}/etc/tivoli/dsm.sys"
	echo '	 ErrorLogName "/var/log/tsm/dsmerror.log"' >> "${ED}/etc/tivoli/dsm.sys"
	echo '	 SchedLogName "/var/log/tsm/dsmsched.log"' >> "${ED}/etc/tivoli/dsm.sys"
	dosym ../../../../../../etc/tivoli/dsm.sys /opt/tivoli/tsm/client/ba/bin/dsm.sys

	cp -a "${ED}/opt/tivoli/tsm/client/ba/bin/dsm.opt.smp" "${ED}/etc/tivoli/dsm.opt" || die
	dosym ../../../../../../etc/tivoli/dsm.opt /opt/tivoli/tsm/client/ba/bin/dsm.opt

	if use journal; then
		touch "${ED}/etc/tivoli/tsmjbbd.ini" || die
		dosym ../../../../../../etc/tivoli/tsmjbbd.ini /opt/tivoli/tsm/client/ba/bin/tsmjbbd.ini
	fi

	chown -R root:tsm "${ED}/etc/tivoli" || die
	chmod -R 0660 "${ED}/etc/tivoli/"* || die

	# Setup the env
	newenvd - 80tivoli <<-EOF
		DSM_CONFIG="/etc/tivoli/dsm.opt"
		DSM_DIR="/opt/tivoli/tsm/client/ba/bin"
		DSM_LOG="/var/log/tsm"
		# ROOTPATH="/opt/tivoli/tsm/client/ba/bin"
	EOF

	insinto /etc/revdep-rebuild
	newins - 80${PN} <<-EOF
		SEARCH_DIRS_MASK="/opt/tivoli/tsm/client/ba/bin"
	EOF

	# https://www.ibm.com/support/pages/apar/IT46420
	insinto /etc/tivoli
	newins - dsmcad.lang <<-EOF
		LANG=en_US
		LC_ALL=en_US
	EOF
	dosym ../../../../../../etc/tivoli/dsmcad.lang /opt/tivoli/tsm/client/ba/bin/dsmcad.lang

	# Need this for hardened, otherwise a cryptic "connection to server lost" message appears
	pax-mark -m "${ED}/opt/tivoli/tsm/client/ba/bin/dsmc"

	if use gui; then
		magick "${ED}/opt/tivoli/tsm/client/ba/bin/favicon.ico" "${T}/ibm.png" || die
		doicon -s 16 "${T}/ibm.png"
		make_desktop_entry dsmj "IBM Storage Protect" ibm System

		# Respect our java setting
		sed -e '/JAVA_HOME=/d' \
			-i "${ED}/opt/tivoli/tsm/tdpvmware/common/scripts/webserver" || die
	fi

	# Ensure the services can start on Gentoo, respect our java setting
	sed -e 's/Ubuntu/Gentoo/g' \
		-i "${ED}/opt/tivoli/tsm/client/ba/bin/rc."* || die
	sed -e 's/DSM_LOG=\/opt\/tivoli\/tsm\/client\/ba\/bin/DSM_LOG=\/var\/log\/tsm/g' \
		-e '/JAVA_HOME=/d' \
		-e '/PATH=/d' \
		-e '/LD_LIBRARY_PATH=/d' \
		-i "${ED}/opt/tivoli/tsm/client/ba/bin/"*.service || die

	# Overwrite with relative symlinks
	dosym ../../opt/tivoli/tsm/client/ba/bin/rc.dsmcad /etc/init.d/dsmcad
	if use gui; then
		dosym ../../opt/tivoli/tsm/tdpvmware/common/scripts/webserver /etc/init.d/webserver
	else
		rm -f "${ED}/etc/init.d/webserver" || die
	fi
	if use journal; then
		dosym ../../opt/tivoli/tsm/client/ba/bin/rc.tsmjbb /etc/init.d/tsmjbbd
	else
		rm -f "${ED}/etc/init.d/tsmjbbd" || die
	fi

	dosym ../../../../opt/tivoli/tsm/client/ba/bin/dsmcad.service /usr/lib/systemd/system/dsmcad.service
	if use journal; then
		dosym ../../../../opt/tivoli/tsm/client/ba/bin/tsmjbbd.service /usr/lib/systemd/system/tsmjbbd.service
	else
		rm -f "${ED}/usr/lib/systemd/system/tsmjbbd.service" || die
	fi

	# Unbundle ssl
	rm "${ED}/opt/tivoli/tsm/client/api/bin64/libcrypto.so.3" || die
	dosym ../../../../../../usr/$(get_libdir)/libcrypto.so.3 \
		/opt/tivoli/tsm/client/api/bin64/libcrypto.so.3
	rm "${ED}/opt/tivoli/tsm/client/api/bin64/libssl.so.3" || die
	dosym ../../../../../../usr/$(get_libdir)/libssl.so.3 \
		/opt/tivoli/tsm/client/api/bin64/libssl.so.3
	if ! use gpfs; then
		rm "${ED}/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libcrypto.so.3" || die
		dosym /../../../../../../../../usr/$(get_libdir)/libcrypto.so.3 \
			/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libcrypto.so.3
		rm "${ED}/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libssl.so.3" || die
		dosym /../../../../../../../../usr/$(get_libdir)/libssl.so.3 \
			/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libssl.so.3
		# Unbundle curl
		rm "${ED}/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libcurl.so" || die
		dosym /../../../../../../../../usr/$(get_libdir)/libcurl.so \
			/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libcurl.so
		# Unbundle json-c
		rm "${ED}/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libjson-c.so" || die
		dosym /../../../../../../../../usr/$(get_libdir)/libjson-c.so \
			/opt/tivoli/tsm/client/ba/bin/plugins/netappmgm/libjson-c.so
	fi

	linux-mod-r1_src_install
}

pkg_postinst() {
	xdg_pkg_postinst

	local i dirs
	for i in "${EROOT}/var/log/tsm/dsm"{error,instr,j,sched,webcl}.log; do
		if [[ ! -e ${i} ]]; then
			touch ${i} || die
			chown root:tsm ${i} || die
			chmod 0660 ${i} || die
		fi
	done

	# Bug #375041: the log directory itself should not be world writable.
	# Have to do this in postinst due to bug #141619
	chown root:tsm "${EROOT}/var/log/tsm" || die
	chmod 0750 "${EROOT}/var/log/tsm" || die

	# Bug 508052: directories used to be too restrictive, have to widen perms.
	dirs=( "${EROOT}/opt/tivoli" $(find "${EROOT}/opt/tivoli/tsm" -type d) )
	chown root:root "${dirs[@]}" || die
	chmod 0755 "${dirs[@]}" || die

	linux-mod-r1_pkg_postinst

	elog
	elog "To use the client as a regular user, add the user to the \"tsm\" group"
}
