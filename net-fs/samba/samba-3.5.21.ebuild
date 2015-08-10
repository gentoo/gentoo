# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit pam versionator multilib eutils flag-o-matic

MY_PV=${PV/_/}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Library bits of the samba network filesystem"
HOMEPAGE="http://www.samba.org/"
SRC_URI="mirror://samba/stable/${P}.tar.gz
	http://dev.gentoo.org/~dagger/files/smb_traffic_analyzer_v2.diff.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="acl addns ads +aio avahi caps +client cluster debug doc examples fam
	ldap ldb +netapi pam quota +readline selinux +server +smbclient smbsharemodes smbtav2
	swat syslog winbind"

DEPEND="dev-libs/popt
	!net-fs/samba-client
	!net-fs/samba-libs
	!net-fs/samba-server
	!net-fs/cifs-utils
	sys-libs/talloc
	sys-libs/tdb
	virtual/libiconv
	ads? ( virtual/krb5 sys-fs/e2fsprogs
		client? ( sys-apps/keyutils ) )
	avahi? ( net-dns/avahi[dbus] )
	caps? ( sys-libs/libcap )
	client? ( !net-fs/mount-cifs
		dev-libs/iniparser:0 )
	cluster? ( >=dev-db/ctdb-1.0.114_p1 )
	fam? ( virtual/fam )
	ldap? ( net-nds/openldap )
	pam? ( virtual/pam
		winbind? ( dev-libs/iniparser:0 )
	)
	readline? ( >=sys-libs/readline-5.2 )
	selinux? ( sec-policy/selinux-samba )
	syslog? ( virtual/logger )"

RDEPEND="${DEPEND}"

# Disable tests since we don't want to build that much here
RESTRICT="test"

SBINPROGS=""
BINPROGS=""
KRBPLUGIN=""
PLUGINEXT=".so"
SHAREDMODS=""

S="${WORKDIR}/${MY_P}/source3"

# TODO:
# - enable iPrint on Prefix/OSX and Darwin?
# - selftest-prefix? selftest?
# - AFS?

CONFDIR="${FILESDIR}/$(get_version_component_range 1-2)"

REQUIRED_USE="
	ads? ( ldap )
	swat? ( server )
"

pkg_setup() {
	if use server ; then
		SBINPROGS="${SBINPROGS} bin/smbd bin/nmbd"
		BINPROGS="${BINPROGS} bin/testparm bin/smbstatus bin/smbcontrol bin/pdbedit
			bin/profiles bin/sharesec bin/eventlogadm"

		use smbtav2 && BINPROGS="${BINPROGS} bin/smbta-util"
		use swat && SBINPROGS="${SBINPROGS} bin/swat"
		use winbind && SBINPROGS="${SBINPROGS} bin/winbindd"
		use ads && use winbind && KRBPLUGIN="${KRBPLUGIN} bin/winbind_krb5_locator"
	fi

	if use client ; then
		BINPROGS="${BINPROGS} bin/smbclient bin/net bin/smbget bin/smbtree
			bin/nmblookup bin/smbpasswd bin/rpcclient bin/smbcacls bin/smbcquotas
			bin/ntlm_auth"

		use ads && SBINPROGS="${SBINPROGS} bin/cifs.upcall"
	fi

	use ldb && BINPROGS="${BINPROGS} bin/ldbedit bin/ldbsearch bin/ldbadd bin/ldbdel bin/ldbmodify bin/ldbrename";

	if use winbind ; then
		BINPROGS="${BINPROGS} bin/wbinfo"
		SHAREDMODS="${SHAREDMODS}idmap_rid,idmap_hash"
		use ads && SHAREDMODS="${SHAREDMODS},idmap_ad"
		use ldap && SHAREDMODS="${SHAREDMODS},idmap_ldap,idmap_adex"
	fi

	if use winbind &&
		[[ $(tc-getCC)$ == *gcc* ]] &&
		[[ $(gcc-major-version)$(gcc-minor-version) -lt 43 ]]
	then
		eerror "It is a known issue that ${P} will not build with "
		eerror "winbind use flag enabled when using gcc < 4.3 ."
		eerror "Please use at least the latest stable gcc version."
		die "Using sys-devel/gcc < 4.3 with winbind use flag."
	fi
}

src_prepare() {
	cp "${FILESDIR}/samba-3.4.2-lib.tevent.python.mk" "../lib/tevent/python.mk"

	# ensure that winbind has correct ldflags (QA notice)
	sed -i \
		-e 's|LDSHFLAGS="|LDSHFLAGS="\\${LDFLAGS} |g' \
		configure || die "sed failed"

	epatch "${CONFDIR}"/${PN}-3.5.6-kerberos-dummy.patch
	use smbtav2 && cd "${WORKDIR}/${P}" && epatch "${WORKDIR}"/smb_traffic_analyzer_v2.diff
	cd "${WORKDIR}/${MY_P}" && epatch "${CONFDIR}"/${PN}-3.5.8-uclib-build.patch
	epatch "${CONFDIR}"/smb.conf.default.patch
}

src_configure() {
	local myconf

	# Filter out -fPIE
	[[ ${CHOST} == *-*bsd* ]] && myconf+=" --disable-pie"

	#Allowing alpha/s390/sh to build
	if use alpha || use s390 || use sh; then
		replace-flags -O? -O1
	fi

	# Upstream refuses to make this configurable
	use caps && export ac_cv_header_sys_capability_h=yes || export ac_cv_header_sys_capability_h=no

	# use_with doesn't accept 2 USE-flags
	if use client && use ads ; then
		myconf+=" --with-cifsupcall"
	else
		myconf+=" --without-cifsupcall"
	fi

	if use client && use kernel_linux ; then
		myconf+=" --with-cifsmount --with-cifsumount"
	else
		myconf+=" --without-cifsmount --without-cifsumount"
	fi

	#bug #399141 wrap newer iniparser version
	has_version ">=dev-libs/iniparser-3.0.0:0" && \
		export CPPFLAGS+=" -Diniparser_getstr\(d,i\)=iniparser_getstring\(d,i,NULL\)"

	# Notes:
	# - automount is only needed in conjunction with NIS and we don't have that
	# anymore => LDAP?
	# - --without-dce-dfs and --without-nisplus-home can't be passed to configure but are disabled by default
	econf ${myconf} \
		--with-piddir=/var/run/samba \
		--sysconfdir=/etc/samba \
		--localstatedir=/var \
		$(use_enable debug developer) \
		--enable-largefile \
		--enable-socket-wrapper \
		--enable-nss-wrapper \
		$(use_enable swat) \
		--disable-cups \
		--disable-iprint \
		$(use_enable fam) \
		--enable-shared-libs \
		--disable-dnssd \
		$(use_enable avahi) \
		--with-fhs \
		--with-privatedir=/var/lib/samba/private \
		--with-rootsbindir=/var/cache/samba \
		--with-lockdir=/var/cache/samba \
		--with-swatdir=/usr/share/doc/${PF}/swat \
		--with-configdir=/etc/samba \
		--with-logfilebase=/var/log/samba \
		--with-pammodulesdir=$(getpam_mod_dir) \
		--without-afs \
		--without-fake-kaserver \
		--without-vfs-afsacl \
		$(use_with ldap) \
		$(use_with ads) \
		$(use_with ads krb5 /usr) \
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
		$(use_with cluster ctdb /usr) \
		$(use_with cluster cluster-support) \
		$(use_with acl acl-support) \
		$(use_with aio aio-support) \
		--with-sendfile-support \
		$(use_with winbind) \
		--with-shared-modules=${SHAREDMODS} \
		--without-included-popt \
		--without-included-iniparser
}

src_compile() {
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
	if [ -n "${BINPROGS}" ] ; then
		einfo "make binprogs"
		emake ${BINPROGS}
	fi
	if [ -n "${SBINPROGS}" ] ; then
		einfo "make sbinprogs"
		emake ${SBINPROGS}
	fi

	if [ -n "${KRBPLUGIN}" ] ; then
		einfo "make krbplugin"
		emake ${KRBPLUGIN}${PLUGINEXT}
	fi

	if use client && use kernel_linux; then
		einfo "make {,u}mount.cifs"
		emake bin/{,u}mount.cifs
	fi
}

src_install() {
	# install libs
	if use addns ; then
		einfo "install addns library"
		emake installlibaddns DESTDIR="${D}"
	fi
	if use netapi ; then
		einfo "install netapi library"
		emake installlibnetapi DESTDIR="${D}"
	fi
	if use smbclient ; then
		einfo "install smbclient library"
		emake installlibsmbclient DESTDIR="${D}"
	fi
	if use smbsharemodes ; then
		einfo "install smbsharemodes library"
		emake installlibsmbsharemodes DESTDIR="${D}"
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
	insinto /usr
	for prog in ${SBINPROGS} ; do
		dosbin ${prog}
		doman ../docs/manpages/${prog/bin\/}*
	done

	for prog in ${BINPROGS} ; do
		dobin ${prog}
		doman ../docs/manpages/${prog/bin\/}*
	done

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

	# install server components
	if use server ; then
		doman ../docs/manpages/vfs* ../docs/manpages/samba.7

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
			doins ../examples/LDAP/samba.schema
		fi

		if use swat ; then
			insinto /etc/xinetd.d
			newins "${CONFDIR}/swat.xinetd" swat
			script/installswat.sh "${D}" "${ROOT}/usr/share/doc/${PF}/swat" "${S}"
		fi

		dodoc ../MAINTAINERS ../README* ../Roadmap ../WHATSNEW.txt ../docs/THANKS
	fi

	# install client files ({u,}mount.cifs into /)
	if use client && use kernel_linux ; then
		into /
		dosbin bin/{u,}mount.cifs
		doman ../docs/manpages/{u,}mount.cifs.8
	fi

	# install misc files
	insinto /etc/samba
	doins ../examples/smb.conf.default
	doman  ../docs/manpages/smb.conf.5

	insinto /usr/"$(get_libdir)"/samba
	doins ../codepages/{valid.dat,upcase.dat,lowcase.dat}

	# install docs
	if use doc ; then
		dohtml -r ../docs/htmldocs/*
		dodoc ../docs/*.pdf
	fi

	# install examples
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples

		if use smbclient ; then
			doins -r ../examples/libsmbclient
		fi

		if use winbind ; then
			doins -r ../examples/pam_winbind ../examples/nss
		fi

		if use server ; then
			cd ../examples
			doins -r auth autofs dce-dfs LDAP logon misc pdb \
			perfcounter printer-accounting printing scripts tridge \
			validchars VFS
		fi
	fi

	# Remove empty installation directories
	rmdir --ignore-fail-on-non-empty \
		"${D}/usr/$(get_libdir)/samba" \
		"${D}/usr"/{sbin,bin} \
		"${D}/usr/share"/{man,locale,} \
		"${D}/var"/{run,lib/samba/private,lib/samba,lib,cache/samba,cache,} \
	#	|| die "tried to remove non-empty dirs, this seems like a bug in the ebuild"
}

pkg_postinst() {
	elog "The default value of 'wide links' has been changed to 'no' in samba 3.5"
	elog "to avoid an insecure default configuration"
	elog "('wide links = yes' and 'unix extensions = yes'). For more details,"
	elog "please see http://www.samba.org/samba/news/symlink_attack.html ."
	elog ""
	elog "An EXPERIMENTAL implementation of the SMB2 protocol has been added."
	elog "SMB2 can be enabled by setting 'max protocol = smb2'. SMB2 is a new "
	elog "implementation of the SMB protocol used by Windows Vista and higher"
	elog ""
	elog "For further information make sure to read the release notes at"
	elog "http://samba.org/samba/history/${P}.html and "
	elog "http://samba.org/samba/history/${PN}-3.5.0.html"
}
