# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/samba/samba-3.6.25.ebuild,v 1.3 2015/02/25 19:28:09 jer Exp $

EAPI=5

inherit pam versionator multilib multilib-minimal eutils flag-o-matic systemd

MY_PV=${PV/_/}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Library bits of the samba network filesystem"
HOMEPAGE="http://www.samba.org/"
SRC_URI="mirror://samba/stable/${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="acl addns ads +aio avahi caps +client cluster cups debug dmapi doc examples fam
	ldap ldb +netapi pam quota +readline selinux +server +smbclient smbsharemodes
	swat syslog +winbind"

DEPEND="dev-libs/popt
	>=sys-libs/talloc-2.0.8-r1[${MULTILIB_USEDEP}]
	>=sys-libs/tdb-1.2.13[${MULTILIB_USEDEP}]
	>=sys-libs/tevent-0.9.19[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	ads? ( >=virtual/krb5-0-r1[${MULTILIB_USEDEP}] sys-fs/e2fsprogs
		client? ( sys-apps/keyutils ) )
	avahi? ( net-dns/avahi[dbus] )
	caps? ( >=sys-libs/libcap-2.22-r2[${MULTILIB_USEDEP}] )
	client? ( !net-fs/mount-cifs
		>=dev-libs/iniparser-3.1-r1[${MULTILIB_USEDEP}] )
	cluster? ( >=dev-db/ctdb-1.13 )
	cups? ( net-print/cups )
	debug? ( dev-libs/dmalloc )
	dmapi? ( sys-apps/dmapi )
	fam? ( >=virtual/fam-0-r1[${MULTILIB_USEDEP}] )
	ldap? ( >=net-nds/openldap-2.4.38-r1[${MULTILIB_USEDEP}] )
	ldb? ( sys-libs/ldb )
	pam? ( >=virtual/pam-0-r1[${MULTILIB_USEDEP}]
		winbind? ( >=dev-libs/iniparser-3.1-r1[${MULTILIB_USEDEP}] )
	)
	readline? ( >=sys-libs/readline-5.2:= )
	syslog? ( virtual/logger )"

RDEPEND="${DEPEND}
	kernel_linux? ( ads? ( net-fs/cifs-utils[ads] )
			client? ( net-fs/cifs-utils ) )
	selinux? ( sec-policy/selinux-samba )
"

# Disable tests since we don't want to build that much here
RESTRICT="test"

SBINPROGS=""
BINPROGS=""
KRBPLUGIN=""
PLUGINEXT=".so"
SHAREDMODS=""

S=${WORKDIR}/${MY_P}

# TODO:
# - enable iPrint on Prefix/OSX and Darwin?
# - selftest-prefix? selftest?
# - AFS?

CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"

REQUIRED_USE="
	ads? ( ldap )
	swat? ( server )
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if use winbind &&
			[[ $(tc-getCC)$ == *gcc* ]] &&
			[[ $(gcc-major-version)$(gcc-minor-version) -lt 43 ]]
		then
			eerror "It is a known issue that ${P} will not build with "
			eerror "winbind use flag enabled when using gcc < 4.3 ."
			eerror "Please use at least the latest stable gcc version."
			die "Using sys-devel/gcc < 4.3 with winbind use flag."
		fi
	fi
}

pkg_setup() {
	if use server ; then
		SBINPROGS="${SBINPROGS} bin/smbd bin/nmbd"
		BINPROGS="${BINPROGS} bin/testparm bin/smbstatus bin/smbcontrol bin/pdbedit
			bin/profiles bin/sharesec bin/eventlogadm bin/smbta-util
			$(usex client "" "bin/smbclient")"

		use swat && SBINPROGS="${SBINPROGS} bin/swat"
		use winbind && SBINPROGS="${SBINPROGS} bin/winbindd"
		use ads && use winbind && KRBPLUGIN="${KRBPLUGIN} bin/winbind_krb5_locator"
	fi

	if use client ; then
		BINPROGS="${BINPROGS} bin/smbclient bin/net bin/smbget bin/smbtree
			bin/nmblookup bin/smbpasswd bin/rpcclient bin/smbcacls bin/smbcquotas
			bin/ntlm_auth"

	fi

	use cups && BINPROGS="${BINPROGS} bin/smbspool"
#	use ldb && BINPROGS="${BINPROGS} bin/ldbedit bin/ldbsearch bin/ldbadd bin/ldbdel bin/ldbmodify bin/ldbrename";

	if use winbind ; then
		BINPROGS="${BINPROGS} bin/wbinfo"
		SHAREDMODS="${SHAREDMODS}idmap_rid,idmap_hash"
		use ads && SHAREDMODS="${SHAREDMODS},idmap_ad"
		use cluster && SHAREDMODS="${SHAREDMODS},idmap_tdb2"
		use ldap && SHAREDMODS="${SHAREDMODS},idmap_ldap,idmap_adex"
	fi
}

src_prepare() {
	cp "${FILESDIR}/samba-3.4.2-lib.tevent.python.mk" "lib/tevent/python.mk"

	# ensure that winbind has correct ldflags (QA notice)
	sed -i \
		-e 's|LDSHFLAGS="|LDSHFLAGS="\\${LDFLAGS} |g' \
		source3/configure || die "sed failed"
	epatch "${CONFDIR}"/smb.conf.default.patch

	#bug #399141 wrap newer iniparser version
	has_version ">=dev-libs/iniparser-3.0.0" && \
		append-cppflags "-Diniparser_getstr\(d,i\)=iniparser_getstring\(d,i,NULL\)"

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=()

	# we can't alter S since build system writes to '../' and therefore
	# we need to duplicate the whole structure
	cd source3 || die

	# Filter out -fPIE
	[[ ${CHOST} == *-*bsd* ]] && myconf+=( --disable-pie )

	#Allowing alpha/s390/sh to build
	if use alpha || [[ ${ABI} == s390 ]] || use sh ; then
		local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}
		replace-flags -O? -O1
	fi

	# http://wiki.samba.org/index.php/CTDB_Setup
	use cluster && myconf+=( --disable-pie )

	# Upstream refuses to make this configurable
	myconf+=( ac_cv_header_sys_capability_h=$(usex caps) )

	# Notes:
	# - automount is only needed in conjunction with NIS and we don't have that
	# anymore => LDAP?
	# - --without-dce-dfs and --without-nisplus-home can't be passed to configure but are disabled by default
	econf "${myconf[@]}" \
		--with-piddir="${EPREFIX}"/var/run/samba \
		--sysconfdir="${EPREFIX}"/etc/samba \
		--localstatedir="${EPREFIX}"/var \
		$(multilib_native_use_enable debug developer) \
		--enable-largefile \
		--enable-socket-wrapper \
		--enable-nss-wrapper \
		$(multilib_native_use_enable swat) \
		$(multilib_native_use_enable debug dmalloc) \
		$(multilib_native_use_enable cups) \
		--disable-iprint \
		$(use_enable fam) \
		--enable-shared-libs \
		--disable-dnssd \
		$(multilib_native_use_enable avahi) \
		--with-fhs \
		--with-privatedir="${EPREFIX}"/var/lib/samba/private \
		--with-rootsbindir="${EPREFIX}"/var/cache/samba \
		--with-lockdir="${EPREFIX}"/var/cache/samba \
		--with-swatdir="${EPREFIX}"/usr/share/doc/${PF}/swat \
		--with-configdir="${EPREFIX}"/etc/samba \
		--with-logfilebase="${EPREFIX}"/var/log/samba \
		--with-pammodulesdir=$(getpam_mod_dir) \
		$(multilib_native_use_with dmapi) \
		--without-afs \
		--without-fake-kaserver \
		--without-vfs-afsacl \
		$(use_with ldap) \
		$(use_with ads) \
		$(use_with ads krb5 "${EPREFIX}"/usr) \
		$(use_with ads dnsupdate) \
		--without-automount \
		$(use_with pam) \
		$(use_with pam pam_smbpass) \
		$(use_with syslog) \
		$(use_with quota quotas) \
		$(use_with quota sys-quotas) \
		--without-utmp \
		--without-lib{talloc,tdb} \
		$(use_with netapi libnetapi) \
		$(use_with smbclient libsmbclient) \
		$(use_with smbsharemodes libsmbsharemodes) \
		$(use_with addns libaddns) \
		$(use_with cluster ctdb "${EPREFIX}"/usr) \
		$(use_with cluster cluster-support) \
		$(multilib_native_use_with acl acl-support) \
		$(use_with aio aio-support) \
		--with-sendfile-support \
		$(use_with winbind) \
		--with-shared-modules=${SHAREDMODS} \
		--without-included-popt \
		--without-included-iniparser
}

multilib_src_compile() {
	cd source3 || die

	# compile libs
	if use addns ; then
		einfo "make addns library"
		emake libaddns
	fi
	if use netapi ; then
		einfo "make netapi library"
		emake libnetapi
	fi
	if use smbclient ; then
		einfo "make smbclient library"
		emake libsmbclient
	fi
	if use smbsharemodes ; then
		einfo "make smbsharemodes library"
		emake libsmbsharemodes
	fi

	# compile modules
	emake modules

	# compile pam moudles
	if use pam ; then
		einfo "make pam modules"
		emake pam_modules
	fi

	# compile winbind nss modules
	if use winbind ; then
		einfo "make nss modules"
		emake nss_modules
	fi

	# compile utilities
	if multilib_is_native_abi; then
		if [ -n "${BINPROGS}" ] ; then
			einfo "make binprogs"
			emake ${BINPROGS}
		fi
		if [ -n "${SBINPROGS}" ] ; then
			einfo "make sbinprogs"
			emake ${SBINPROGS}
		fi
	fi

	if [ -n "${KRBPLUGIN}" ] ; then
		einfo "make krbplugin"
		emake ${KRBPLUGIN}${PLUGINEXT}
	fi
}

multilib_src_install() {
	cd source3 || die

	# pkgconfig files installation needed, bug #464818
	local pkgconfigdir=/usr/$(get_libdir)/pkgconfig

	# install libs
	if use addns ; then
		einfo "install addns library"
		emake installlibaddns DESTDIR="${D}"
	fi
	if use netapi ; then
		einfo "install netapi library"
		emake installlibnetapi DESTDIR="${D}"
		insinto $pkgconfigdir
		doins pkgconfig/netapi.pc
	fi
	if use smbclient ; then
		einfo "install smbclient library"
		emake installlibsmbclient DESTDIR="${D}"
		insinto $pkgconfigdir
		doins pkgconfig/smbclient.pc
	fi
	if use smbsharemodes ; then
		einfo "install smbsharemodes library"
		emake installlibsmbsharemodes DESTDIR="${D}"
		insinto $pkgconfigdir
		doins pkgconfig/smbsharemodes.pc
	fi

	# install modules
	emake installmodules DESTDIR="${D}"

	if use pam ; then
		einfo "install pam modules"
		emake installpammodules DESTDIR="${D}"

		if use winbind ; then
			newpamd "${CONFDIR}/system-auth-winbind.pam" system-auth-winbind
			doman ../docs/manpages/pam_winbind.8
			# bug #376853
			insinto /etc/security
			doins ../examples/pam_winbind/pam_winbind.conf || die
		fi

		newpamd "${CONFDIR}/samba.pam" samba
		dodoc pam_smbpass/README
	fi

	# Nsswitch extensions. Make link for wins and winbind resolvers
	if use winbind ; then
		einfo "install libwbclient"
		emake installlibwbclient DESTDIR="${D}"
		dolib.so ../nsswitch/libnss_wins.so
		dosym libnss_wins.so /usr/$(get_libdir)/libnss_wins.so.2
		dolib.so ../nsswitch/libnss_winbind.so
		dosym libnss_winbind.so /usr/$(get_libdir)/libnss_winbind.so.2
		insinto $pkgconfigdir
		doins pkgconfig/wbclient.pc
		einfo "install libwbclient related manpages"
		doman ../docs/manpages/idmap_rid.8
		doman ../docs/manpages/idmap_hash.8
		if use ldap ; then
			doman ../docs/manpages/idmap_adex.8
			doman ../docs/manpages/idmap_ldap.8
		fi
		if use ads ; then
			doman ../docs/manpages/idmap_ad.8
		fi
	fi

	# install binaries
	if multilib_is_native_abi; then
		insinto /usr
		for prog in ${SBINPROGS} ; do
			dosbin ${prog}
			doman ../docs/manpages/${prog/bin\/}*
		done

		for prog in ${BINPROGS} ; do
			dobin ${prog}
			doman ../docs/manpages/${prog/bin\/}*
		done

		# install scripts
		if use client ; then
			dobin script/findsmb
			doman ../docs/manpages/findsmb.1
		fi
	fi

	# install krbplugin
	if [ -n "${KRBPLUGIN}" ] ; then
		if has_version app-crypt/mit-krb5 ; then
			insinto /usr/$(get_libdir)/krb5/plugins/libkrb5
			doins ${KRBPLUGIN}${PLUGINEXT}
		elif has_version app-crypt/heimdal ; then
			insinto /usr/$(get_libdir)/plugin/krb5
			doins ${KRBPLUGIN}${PLUGINEXT}
		fi
		insinto /usr
		for prog in ${KRBPLUGIN} ; do
			doman ../docs/manpages/${prog/bin\/}*
		done
	fi
}

multilib_src_install_all() {
	# install server components
	if use server ; then
		doman docs/manpages/vfs* docs/manpages/samba.7

		diropts -m0700
		keepdir /var/lib/samba/private

		diropts -m1777
		keepdir /var/spool/samba

		diropts -m0755
		keepdir /var/{cache,log}/samba
		keepdir /var/lib/samba/{netlogon,profiles}
		keepdir /var/lib/samba/printers/{W32X86,WIN40,W32ALPHA,W32MIPS,W32PPC,X64,IA64,COLOR}
		keepdir /usr/$(get_libdir)/samba/{auth,pdb,rpc,idmap,nss_info,gpext}

		newconfd "${CONFDIR}/samba.confd" samba
		newinitd "${CONFDIR}/samba.initd" samba

		insinto /etc/samba
		doins "${CONFDIR}"/{smbusers,lmhosts}

		if use ldap ; then
			insinto /etc/openldap/schema
			doins examples/LDAP/samba.schema
		fi

		if use swat ; then
			insinto /etc/xinetd.d
			newins "${CONFDIR}/swat.xinetd" swat
			script/installswat.sh "${ED}" "${EROOT}/usr/share/doc/${PF}/swat" "${S}"
		fi

		dodoc MAINTAINERS.txt README* Roadmap WHATSNEW.txt docs/THANKS
	fi

	# install the spooler to cups
	if use cups ; then
		dosym /usr/bin/smbspool $(cups-config --serverbin)/backend/smb
	fi

	# install misc files
	insinto /etc/samba
	doins examples/smb.conf.default
	doman docs/manpages/smb.conf.5

	insinto /usr/"$(get_libdir)"/samba
	doins codepages/{valid.dat,upcase.dat,lowcase.dat}

	# install docs
	if use doc ; then
		dohtml -r docs/htmldocs/.
		dodoc docs/*.pdf
	fi

	# install examples
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples

		if use smbclient ; then
			doins -r examples/libsmbclient
		fi

		if use winbind ; then
			doins -r examples/pam_winbind examples/nss
		fi

		if use server ; then
			cd examples || die
			doins -r auth autofs dce-dfs LDAP logon misc pdb \
				perfcounter printer-accounting printing scripts tridge \
				validchars VFS
		fi
	fi

	# Remove empty installation directories
	rmdir --ignore-fail-on-non-empty \
		"${ED}/usr/$(get_libdir)/samba" \
		"${ED}/usr"/{sbin,bin} \
		"${ED}/usr/share"/{man,locale,} \
		"${ED}/var"/{run,lib/samba/private,lib/samba,lib,cache/samba,cache,} \
	#	|| die "tried to remove non-empty dirs, this seems like a bug in the ebuild"

	systemd_dotmpfilesd "${FILESDIR}"/samba.conf
	systemd_dounit "${FILESDIR}"/nmbd.service
	systemd_dounit "${FILESDIR}"/smbd.{service,socket}
	systemd_newunit "${FILESDIR}"/smbd_at.service 'smbd@.service'
	systemd_dounit "${FILESDIR}"/winbindd.service
}

pkg_postinst() {
	elog "Samba 3.6 has adopted a number of improved security defaults that"
	elog "will impact on existing users of Samba."
	elog "			client ntlmv2 auth = yes"
	elog "			client use spnego principal = no"
	elog "			send spnego principal = no"
	elog ""
	elog "SMB2 protocol support in 3.6.0 is fully functional and can be "
	elog "enabled by setting 'max protocol = smb2'. SMB2 is a new "
	elog "implementation of the SMB protocol used by Windows Vista and higher"
	elog ""
	elog "For further information make sure to read the release notes at"
	elog "http://samba.org/samba/history/${P}.html and "
	elog "http://samba.org/samba/history/${PN}-3.6.0.html"
}
