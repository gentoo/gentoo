# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info pam toolchain-funcs

PATCH_TARBALL_NAME="${PN}-2.4.9-patches-03"
DESCRIPTION="Point-to-Point Protocol (PPP)"
HOMEPAGE="https://ppp.samba.org/"
SRC_URI="https://github.com/paulusmack/ppp/archive/${P}.tar.gz
	https://dev.gentoo.org/~polynomial-c/${PATCH_TARBALL_NAME}.tar.xz
	http://www.netservers.net.uk/gpl/ppp-dhcpc.tgz"

LICENSE="BSD GPL-2"
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="activefilter atm dhcp +eap-tls gtk ipv6 pam radius systemd"

DEPEND="
	dev-libs/openssl:0=
	virtual/libcrypt:=
	activefilter? ( net-libs/libpcap )
	atm? ( net-dialup/linux-atm )
	gtk? ( x11-libs/gtk+:2 )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	!<net-misc/netifrc-0.7.1-r2"
BDEPEND="virtual/pkgconfig"
PDEPEND="net-dialup/ppp-scripts"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	mv "${WORKDIR}/dhcp" "${S}/pppd/plugins" || die

	eapply "${WORKDIR}"/patches
	eapply "${FILESDIR}"/${P}-fix-MPPE-sstpc.patch

	#IPX Support is removed in kernel >= 5.15
	sed -i 's/-DIPX_CHANGE //' pppd/Makefile.linux || die

	if use atm ; then
		einfo "Enabling PPPoATM support"
		sed -i '/^#HAVE_LIBATM=yes/s:#::' \
			pppd/plugins/pppoatm/Makefile.linux || die
	fi

	if ! use activefilter ; then
		einfo "Disabling active filter"
		sed -i '/^FILTER=y/s:^:#:' pppd/Makefile.linux || die
	fi

	if use pam ; then
		einfo "Enabling PAM"
		sed -i '/^#USE_PAM=y/s:^#::' pppd/Makefile.linux || die
	fi

	if ! use ipv6 ; then
		einfo "Disabling IPv6"
		sed -i '/^HAVE_INET6/s:^:#:' pppd/Makefile.linux || die
	else
		echo "+ipv6" >> etc.ppp/options || die
	fi

	einfo "Enabling CBCP"
	sed -i '/^#CBCP=y/s:#::' pppd/Makefile.linux || die

	if use dhcp ; then
		einfo "Adding ppp-dhcp plugin files"
		sed \
			-e '/^SUBDIRS :=/s:$: dhcp:' \
			-i pppd/plugins/Makefile.linux || die
	fi

	if ! use eap-tls ; then
		einfo "Disabling EAP-TLS pppd auth support"
		sed -i '/^USE_EAPTLS=y/s:^:#:' pppd/Makefile.linux || die
		einfo "Disabling EAP-TLS plugin support"
		sed -i '/^CFLAGS += -DUSE_EAPTLS=1/s:^:#:' \
			pppd/plugins/Makefile.linux || die
	fi

	# Set correct libdir
	sed -i -e "s:/lib/pppd:/$(get_libdir)/pppd:" \
		pppd/{pathnames.h,pppd.8} || die

	if use radius ; then
		# Set the right paths in radiusclient.conf
		sed -e "s:/usr/local/etc:/etc:" \
			-e "s:/usr/local/sbin:/usr/sbin:" \
			-i pppd/plugins/radius/etc/radiusclient.conf || die
		# Set config dir to /etc/ppp/radius
		sed -i -e "s:/etc/radiusclient:/etc/ppp/radius:g" \
			pppd/plugins/radius/{*.8,*.c,*.h} \
			pppd/plugins/radius/etc/* || die
	else
		einfo "Disabling radius"
		sed -i -e '/+= radius/s:^:#:' pppd/plugins/Makefile.linux || die
	fi

	if use systemd ; then
		einfo "Enabling systemd notification"
		sed '/SYSTEMD=/s@^#@@' -i pppd/Makefile.linux || die
	fi

	# Respect our pkg-config settings.
	sed -i \
		-e 's:pkg-config:$(PKG_CONFIG):' \
		contrib/pppgetpass/Makefile.linux || die
	sed -i \
		-e '/^LIBS/{s:-L/usr/local/ssl/lib::;s:-lcrypto:`$(PKG_CONFIG) --libs libcrypto`:}' \
		pppd/Makefile.linux || die

	eapply_user #549588
}

src_compile() {
	tc-export AR CC PKG_CONFIG
	emake CC="${CC}" COPTS="${CFLAGS} -D_GNU_SOURCE"

	# build pppgetpass
	cd contrib/pppgetpass || die
	if use gtk ; then
		emake -f Makefile.linux
	else
		emake pppgetpass.vt
	fi
}

src_install() {
	local i
	for i in chat pppd pppdump pppstats ; do
		doman ${i}/${i}.8
		dosbin ${i}/${i}
	done
	fperms u+s-w /usr/sbin/pppd

	# Install pppd header files
	emake -C pppd INSTROOT="${D}" install-devel

	dosbin pppd/plugins/pppoe/pppoe-discovery

	dodir /etc/ppp/peers
	insinto /etc/ppp
	insopts -m0600
	newins etc.ppp/pap-secrets pap-secrets.example
	newins etc.ppp/chap-secrets chap-secrets.example

	insopts -m0644
	doins etc.ppp/options

	if use pam; then
		pamd_mimic_system ppp auth account session
	fi

	local PLUGINS_DIR="/usr/$(get_libdir)/pppd/${PV}"
	insinto "${PLUGINS_DIR}"
	insopts -m0755
	doins pppd/plugins/minconn.so
	doins pppd/plugins/passprompt.so
	doins pppd/plugins/passwordfd.so
	doins pppd/plugins/winbind.so
	doins pppd/plugins/pppoe/pppoe.so
	doins pppd/plugins/pppol2tp/openl2tp.so
	doins pppd/plugins/pppol2tp/pppol2tp.so
	if use atm ; then
		doins pppd/plugins/pppoatm/pppoatm.so
	fi
	if use dhcp ; then
		doins pppd/plugins/dhcp/dhcpc.so
	fi
	if use radius ; then
		doins pppd/plugins/radius/rad{ius,attr,realms}.so

		#Copy radiusclient configuration files (#92878)
		insinto /etc/ppp/radius
		insopts -m0644
		doins pppd/plugins/radius/etc/{dictionary*,issue,port-id-map,radiusclient.conf,realms,servers}

		doman pppd/plugins/radius/pppd-rad{ius,attr}.8
	fi

	insinto /etc/modprobe.d
	insopts -m0644
	newins "${FILESDIR}/modules.ppp" ppp.conf

	dodoc PLUGINS README* SETUP Changes-2.3 FAQ
	dodoc "${FILESDIR}/README.mpls"

	dosbin scripts/p{on,off,log}
	doman scripts/pon.1

	# Adding misc. specialized scripts to doc dir
	dodoc -r scripts
	docinto scripts
	dodoc -r scripts/chatchat

	if use gtk ; then
		dosbin contrib/pppgetpass/{pppgetpass.vt,pppgetpass.gtk}
		newsbin contrib/pppgetpass/pppgetpass.sh pppgetpass
	else
		newsbin contrib/pppgetpass/pppgetpass.vt pppgetpass
	fi
	doman contrib/pppgetpass/pppgetpass.8
}

pkg_postinst() {
	if linux-info_get_any_version && linux_config_src_exists ; then
		echo
		ewarn "If the following test report contains a missing kernel configuration option that you need,"
		ewarn "you should reconfigure and rebuild your kernel before running pppd."
		CONFIG_CHECK="~PPP ~PPP_ASYNC ~PPP_SYNC_TTY"
		local ERROR_PPP="CONFIG_PPP:\t missing PPP support (REQUIRED)"
		local ERROR_PPP_ASYNC="CONFIG_PPP_ASYNC:\t missing asynchronous serial line discipline (optional, but highly recommended)"
		local WARNING_PPP_SYNC_TTY="CONFIG_PPP_SYNC_TTY:\t missing synchronous serial line discipline (optional; used by 'sync' pppd option)"
		if use activefilter ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~PPP_FILTER"
			local ERROR_PPP_FILTER="CONFIG_PPP_FILTER:\t missing PPP filtering support (REQUIRED)"
		fi
		CONFIG_CHECK="${CONFIG_CHECK} ~PPP_DEFLATE ~PPP_BSDCOMP ~PPP_MPPE"
		local ERROR_PPP_DEFLATE="CONFIG_PPP_DEFLATE:\t missing Deflate compression (optional, but highly recommended)"
		local ERROR_PPP_BSDCOMP="CONFIG_PPP_BSDCOMP:\t missing BSD-Compress compression (optional, but highly recommended)"
		local WARNING_PPP_MPPE="CONFIG_PPP_MPPE:\t missing MPPE encryption (optional, mostly used by PPTP links)"
		CONFIG_CHECK="${CONFIG_CHECK} ~PPPOE ~PACKET"
		local WARNING_PPPOE="CONFIG_PPPOE:\t missing PPPoE support (optional, needed by pppoe plugin)"
		local WARNING_PACKET="CONFIG_PACKET:\t missing AF_PACKET support (optional, used by pppoe and dhcpc plugins)"
		if use atm ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~PPPOATM"
			local WARNING_PPPOATM="CONFIG_PPPOATM:\t missing PPPoA support (optional, needed by pppoatm plugin)"
		fi
		check_extra_config
	fi

	# create *-secrets files if not exists
	[[ -f "${EROOT}/etc/ppp/pap-secrets" ]] || \
		cp -pP "${EROOT}/etc/ppp/pap-secrets.example" "${EROOT}/etc/ppp/pap-secrets"
	[[ -f "${EROOT}/etc/ppp/chap-secrets" ]] || \
		cp -pP "${EROOT}/etc/ppp/chap-secrets.example" "${EROOT}/etc/ppp/chap-secrets"

	# lib name has changed
	sed -i -e "s:^rp-\(pppoe.so\):\1:" "${EROOT}/etc/ppp/options" || die

	echo
	elog "Pon, poff and plog scripts have been supplied for experienced users."
	elog "Users needing particular scripts (ssh,rsh,etc.) should check out the"
	elog "/usr/share/doc/${PF}/scripts directory."

	if [[ -n ${REPLACING_VERSIONS} ]] ; then
		ewarn '"rp-pppoe.so" plugin has been renamed to "pppoe.so"'
	fi
}
