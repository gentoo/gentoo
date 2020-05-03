# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

MY_PV="${PV//_alpha/a}"
MY_PV="${MY_PV//_beta/b}"
MY_PV="${MY_PV//_rc/rc}"
MY_PV="${MY_PV//_p/-P}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="ISC Dynamic Host Configuration Protocol (DHCP) client/server"
HOMEPAGE="https://www.isc.org/dhcp"
SRC_URI="ftp://ftp.isc.org/isc/dhcp/${MY_P}.tar.gz
	ftp://ftp.isc.org/isc/dhcp/${MY_PV}/${MY_P}.tar.gz"

LICENSE="MPL-2.0 BSD SSLeay GPL-2" # GPL-2 only for init script
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="+client ipv6 kernel_linux ldap libressl selinux +server ssl vim-syntax"

DEPEND="
	acct-group/dhcp
	acct-user/dhcp
	client? (
		kernel_linux? (
			ipv6? ( sys-apps/iproute2 )
			sys-apps/net-tools
		)
	)
	ldap? (
		net-nds/openldap
		ssl? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl )
		)
	)"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-dhcp )
	vim-syntax? ( app-vim/dhcpd-syntax )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	# handle local bind hell
	cd "${S}"/bind
	unpack ./bind.tar.gz
}

PATCHES=(
	# Gentoo patches - these will probably never be accepted upstream
	# Fix some permission issues
	"${FILESDIR}/${PN}-3.0-fix-perms.patch"

	# Enable dhclient to equery NTP servers
	"${FILESDIR}/${PN}-4.3.6-dhclient-ntp.patch"
	"${FILESDIR}/${PN}-4.3.6-dhclient-resolvconf.patch"

	# Enable dhclient to get extra configuration from stdin
	"${FILESDIR}/${PN}-4.2.2-dhclient-stdin-conf.patch"
	"${FILESDIR}/${PN}-4.3.6-nogateway.patch" #265531
	"${FILESDIR}/${PN}-4.3.6-quieter-ping.patch" #296921
	"${FILESDIR}/${PN}-4.4.0-always-accept-4.patch" #437108
	"${FILESDIR}/${PN}-4.3.6-iproute2-path.patch" #480636
	"${FILESDIR}/${PN}-4.2.5-bindtodevice-inet6.patch" #471142
	"${FILESDIR}/${PN}-4.3.3-ldap-ipv6-client-id.patch" #559832

	# Possible upstream candidates
	"${FILESDIR}/${PN}-4.4.2-fno-common.patch" #710194
)

src_prepare() {
	default

	# Brand the version with Gentoo
	sed -i \
		-e "/VERSION=/s:'$: Gentoo-${PR}':" \
		configure || die

	# Change the hook script locations of the scripts
	sed -i \
		-e 's,/etc/dhclient-exit-hooks,/etc/dhcp/dhclient-exit-hooks,g' \
		-e 's,/etc/dhclient-enter-hooks,/etc/dhcp/dhclient-enter-hooks,g' \
		client/scripts/* || die

	# No need for the linux script to force bash #158540
	sed -i -e 's,#!/bin/bash,#!/bin/sh,' client/scripts/linux || die

	# Quiet the freebsd logger a little
	sed -i -e '/LOGGER=/ s/-s -p user.notice //g' client/scripts/freebsd || die

	# Remove these options from the sample config
	sed -i -r \
		-e "/(script|host-name|domain-name) /d" \
		client/dhclient.conf.example || die

	if use client && ! use server ; then
		sed -i -r \
			-e '/^SUBDIRS/s:\<(dhcpctl|relay|server)\>::g' \
			Makefile.in || die
	elif ! use client && use server ; then
		sed -i -r \
			-e '/^SUBDIRS/s:\<client\>::' \
			Makefile.in || die
	fi

	# Only install different man pages if we don't have en
	if [[ " ${LINGUAS} " != *" en "* ]]; then
		# Install Japanese man pages
		if [[ " ${LINGUAS} " == *" ja "* && -d doc/ja_JP.eucJP ]]; then
			einfo "Installing Japanese documention"
			cp doc/ja_JP.eucJP/dhclient* client || die
			cp doc/ja_JP.eucJP/dhcp* common || die
		fi
	fi
	# Now remove the non-english docs so there are no errors later
	rm -r doc/ja_JP.eucJP || die

	# make the bind build work - do NOT make "binddir" local!
	binddir="${S}/bind"
	cd "${binddir}" || die
	cat <<-EOF > bindvar.tmp
	binddir=${binddir}
	GMAKE=${MAKE:-gmake}
	EOF
	eapply -p2 "${FILESDIR}"/${PN}-4.4.0-bind-disable.patch
	# Only use the relevant subdirs now that ISC
	#removed the lib/export structure in bind.
	sed '/^SUBDIRS/s@=.*$@= isc dns isccfg irs samples@' \
		-i bind-*/lib/Makefile.in || die
}

src_configure() {
	# bind defaults to stupid `/usr/bin/ar`
	tc-export AR BUILD_CC
	export ac_cv_path_AR=${AR}

	# this is tested for by the bind build system, and can cause trouble
	# when cross-building; since dhcp itself doesn't make use of libcap,
	# simply disable it.
	export ac_cv_lib_cap_cap_set_proc=no

	# Use FHS sane paths ... some of these have configure options,
	# but not all, so just do it all here.
	local e="/etc/dhcp" r="/var/run/dhcp" l="/var/lib/dhcp"
	cat <<-EOF >> includes/site.h
	#define _PATH_DHCPD_CONF     "${e}/dhcpd.conf"
	#define _PATH_DHCLIENT_CONF  "${e}/dhclient.conf"
	#define _PATH_DHCPD_DB       "${l}/dhcpd.leases"
	#define _PATH_DHCPD6_DB      "${l}/dhcpd6.leases"
	#define _PATH_DHCLIENT_DB    "${l}/dhclient.leases"
	#define _PATH_DHCLIENT6_DB   "${l}/dhclient6.leases"
	#define _PATH_DHCPD_PID      "${r}/dhcpd.pid"
	#define _PATH_DHCPD6_PID     "${r}/dhcpd6.pid"
	#define _PATH_DHCLIENT_PID   "${r}/dhcpclient.pid"
	#define _PATH_DHCLIENT6_PID  "${r}/dhcpclient6.pid"
	#define _PATH_DHCRELAY_PID   "${r}/dhcrelay.pid"
	#define _PATH_DHCRELAY6_PID  "${r}/dhcrelay6.pid"
	EOF

	local myeconfargs=(
		--enable-paranoia
		--enable-early-chroot
		--sysconfdir=${e}
		$(use_enable ipv6 dhcpv6)
		$(use_with ldap)
		$(use ldap && use_with ssl ldapcrypto || echo --without-ldapcrypto)
	)
	econf "${myeconfargs[@]}"

	# configure local bind cruft.  symtable option requires
	# perl and we don't want to require that #383837.
	cd bind/bind-*/ || die
	local el
	eval econf \
		$(for el in $(awk '/^bindconfig/,/^$/ {print}' ../Makefile.in) ; do if [[ ${el} =~ ^-- ]] ; then printf ' %s' ${el//\\} ; fi ; done | sed 's,@\([[:alpha:]]\+\)dir@,${binddir}/\1,g') \
		--disable-symtable \
		--without-make-clean
}

src_compile() {
	# build local bind cruft first
	emake -C bind/bind-*/lib install
	# then build standard dhcp code
	emake AR="$(tc-getAR)"
}

src_install() {
	default

	dodoc README RELNOTES doc/{api+protocol,IANA-arp-parameters}
	docinto html
	dodoc doc/References.html

	if [[ -e client/dhclient ]] ; then
		# move the client to /
		dodir /sbin
		mv "${ED}"/usr/sbin/dhclient "${ED}"/sbin/ || die

		exeinto /sbin
		if use kernel_linux ; then
			newexe "${S}"/client/scripts/linux dhclient-script
		else
			newexe "${S}"/client/scripts/freebsd dhclient-script
		fi
	fi

	if [[ -e server/dhcpd ]] ; then
		if use ldap ; then
			insinto /etc/openldap/schema
			doins contrib/ldap/dhcp.*
			dosbin contrib/ldap/dhcpd-conf-to-ldap
		fi

		newinitd "${FILESDIR}"/dhcpd.init5 dhcpd
		newconfd "${FILESDIR}"/dhcpd.conf2 dhcpd
		newinitd "${FILESDIR}"/dhcrelay.init3 dhcrelay
		newconfd "${FILESDIR}"/dhcrelay.conf dhcrelay
		newinitd "${FILESDIR}"/dhcrelay.init3 dhcrelay6
		newconfd "${FILESDIR}"/dhcrelay6.conf dhcrelay6

		systemd_newtmpfilesd "${FILESDIR}"/dhcpd.tmpfiles dhcpd.conf
		systemd_dounit "${FILESDIR}"/dhcpd4.service
		systemd_dounit "${FILESDIR}"/dhcpd6.service
		systemd_dounit "${FILESDIR}"/dhcrelay4.service
		systemd_dounit "${FILESDIR}"/dhcrelay6.service
		systemd_install_serviced "${FILESDIR}"/dhcrelay4.service.conf
		systemd_install_serviced "${FILESDIR}"/dhcrelay6.service.conf

		sed -i "s:#@slapd@:$(usex ldap slapd ''):" "${ED}"/etc/init.d/* || die #442560
	fi

	# the default config files aren't terribly useful #384087
	local f
	for f in "${ED}"/etc/dhcp/*.conf.example ; do
		mv "${f}" "${f%.example}" || die
	done
	sed -i '/^[^#]/s:^:#:' "${ED}"/etc/dhcp/*.conf || die

	diropts -m0750 -o dhcp -g dhcp
	keepdir /var/lib/dhcp
}

pkg_preinst() {
	# Keep the user files over the sample ones.  The
	# hashing is to ignore the crappy defaults #384087.
	local f h
	for f in dhclient:da7c8496a96452190aecf9afceef4510 dhcpd:10979e7b71134bd7f04d2a60bd58f070 ; do
		h=${f#*:}
		f="/etc/dhcp/${f%:*}.conf"
		if [ -e "${EROOT}"${f} ] ; then
			case $(md5sum "${EROOT}"${f}) in
				${h}*) ;;
				*) cp -p "${EROOT}"${f} "${ED}"${f};;
			esac
		fi
	done
}

pkg_postinst() {
	if [[ -e "${ROOT}"/etc/init.d/dhcp ]] ; then
		ewarn
		ewarn "WARNING: The dhcp init script has been renamed to dhcpd"
		ewarn "/etc/init.d/dhcp and /etc/conf.d/dhcp need to be removed and"
		ewarn "and dhcp should be removed from the default runlevel"
		ewarn
	fi
}
