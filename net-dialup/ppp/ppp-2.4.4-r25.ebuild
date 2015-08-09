# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils multilib toolchain-funcs linux-info pam

DESCRIPTION="Point-to-Point Protocol (PPP)"
HOMEPAGE="http://www.samba.org/ppp"
SRC_URI="ftp://ftp.samba.org/pub/ppp/${P}.tar.gz
	mirror://gentoo/${P}-gentoo-20091116.tar.gz
	dhcp? ( http://www.netservers.co.uk/gpl/ppp-dhcpc.tgz )"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="activefilter atm dhcp eap-tls gtk ipv6 mppe-mppc pam radius"

DEPEND="activefilter? ( >=net-libs/libpcap-0.9.4 )
	atm? ( net-dialup/linux-atm )
	pam? ( virtual/pam )
	gtk? ( >=x11-libs/gtk+-2.8:2 )
	eap-tls? ( net-misc/curl >=dev-libs/openssl-0.9.7 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use mppe-mppc; then
		echo
		ewarn "The mppe-mppc flag overwrites the pppd native MPPE support with MPPE-MPPC"
		ewarn "patch developed by Jan Dubiec."
		ewarn "The resulted pppd will work only with patched kernels with version <= 2.6.14."
		ewarn "You could obtain the kernel patch from MPPE-MPPC homepage:"
		ewarn "   http://mppe-mppc.alphacron.de/"
		ewarn "CAUTION: MPPC is a U.S. patented algorithm!"
		ewarn "Ask yourself if you really need it and, if you do, consult your lawyer first."
		ebeep
	fi
}

src_prepare() {
	epatch "${WORKDIR}/patch/make-vars.patch"
	epatch "${WORKDIR}/patch/mpls.patch"
	epatch "${WORKDIR}/patch/killaddr-smarter.patch"
	epatch "${WORKDIR}/patch/wait-children.patch"
	epatch "${WORKDIR}/patch/maxoctets-2Glimit.patch"
	epatch "${WORKDIR}/patch/defaultgateway.patch"
	epatch "${WORKDIR}/patch/mschapv2-initialize-response.patch"
	epatch "${WORKDIR}/patch/linkpidfile.patch"
	epatch "${WORKDIR}/patch/qa-fixes.patch"
	epatch "${WORKDIR}/patch/kill-pg.patch"
	epatch "${WORKDIR}/patch/auth-fail.patch"
	epatch "${WORKDIR}/patch/defaultmetric.patch"
	epatch "${WORKDIR}/patch/dev-ppp.patch"
	epatch "${WORKDIR}/patch/gtk2.patch"
	epatch "${WORKDIR}/patch/pppoe-lcp-timeout.patch"
	epatch "${WORKDIR}/patch/passwordfd-read-early.patch"
	epatch "${WORKDIR}/patch/pppd-usepeerwins.patch"
	epatch "${WORKDIR}/patch/connect-errors.patch"
	epatch "${WORKDIR}/patch/ppp-pppoe-mac.patch"

	use eap-tls && {
		# see http://eaptls.spe.net/index.html for more info
		einfo "Enabling EAP-TLS support"
		epatch "${WORKDIR}/patch/eaptls-0.7-gentoo.patch"
		use mppe-mppc || epatch "${WORKDIR}/patch/eaptls-mppe-0.7.patch"
	}

	use mppe-mppc && {
		einfo "Enabling MPPE-MPPC support"
		epatch "${WORKDIR}/patch/mppe-mppc-1.1.patch"
		use eap-tls && epatch "${WORKDIR}/patch/eaptls-mppe-0.7-with-mppc.patch"
	}

	use atm && {
		einfo "Enabling PPPoATM support"
		sed -i "s/^#HAVE_LIBATM=yes/HAVE_LIBATM=yes/" pppd/plugins/pppoatm/Makefile.linux
	}

	use activefilter || {
		einfo "Disabling active filter"
		sed -i "s/^FILTER=y/#FILTER=y/" pppd/Makefile.linux
	}

	use pam && {
		einfo "Enabling PAM"
		sed -i "s/^#USE_PAM=y/USE_PAM=y/" pppd/Makefile.linux
	}

	use ipv6 && {
		einfo "Enabling IPv6"
		sed -i "s/#HAVE_INET6/HAVE_INET6/" pppd/Makefile.linux
	}

	einfo "Enabling CBCP"
	sed -i "s/^#CBCP=y/CBCP=y/" pppd/Makefile.linux

	use dhcp && {
		# copy the ppp-dhcp plugin files
		einfo "Copying ppp-dhcp plugin files..."
		tar -xzf "${DISTDIR}/ppp-dhcpc.tgz" -C pppd/plugins/ \
			&& sed -i -e 's/SUBDIRS := rp-pppoe/SUBDIRS := rp-pppoe dhcp/' pppd/plugins/Makefile.linux \
			|| die "ppp-dhcp plugin addition failed"
		epatch "${WORKDIR}/patch/dhcp-make-vars.patch"
		epatch "${WORKDIR}/patch/dhcp-sys_error_to_strerror.patch"
	}

	# Set correct libdir
	sed -i -e "s:/lib/pppd:/$(get_libdir)/pppd:" \
		pppd/{pathnames.h,pppd.8}

	if use radius; then
		#set the right paths in radiusclient.conf
		sed -i -e "s:/usr/local/etc:/etc:" \
			-e "s:/usr/local/sbin:/usr/sbin:" pppd/plugins/radius/etc/radiusclient.conf
		#set config dir to /etc/ppp/radius
		sed -i -e "s:/etc/radiusclient:/etc/ppp/radius:g" \
			pppd/plugins/radius/{*.8,*.c,*.h} \
			pppd/plugins/radius/etc/*
	else
		einfo "Disabling radius"
		sed -i -e '/+= radius/s:^:#:' pppd/plugins/Makefile.linux
	fi
}

src_configure() {
	export CC="$(tc-getCC)"
	export AR="$(tc-getAR)"
	econf || die "econf failed"
}

src_compile() {
	emake COPTS="${CFLAGS} -D_GNU_SOURCE" || die "compile failed"

	#build pppgetpass
	cd contrib/pppgetpass
	if use gtk; then
		emake -f Makefile.linux || die "failed to build pppgetpass"
	else
		emake pppgetpass.vt || die "failed to build pppgetpass"
	fi
}

src_install() {
	local i
	for i in chat pppd pppdump pppstats ; do
		doman ${i}/${i}.8
		dosbin ${i}/${i} || die
	done
	fperms u+s-w /usr/sbin/pppd

	# Install pppd header files
	pushd pppd >/dev/null
	emake INSTROOT="${D}" install-devel || die
	popd >/dev/null

	dosbin pppd/plugins/rp-pppoe/pppoe-discovery || die

	dodir /etc/ppp/peers
	insinto /etc/ppp
	insopts -m0600
	newins etc.ppp/pap-secrets pap-secrets.example
	newins etc.ppp/chap-secrets chap-secrets.example

	insopts -m0644
	doins etc.ppp/options

	exeinto /etc/ppp
	for i in ip-up ip-down ; do
		doexe "${WORKDIR}/scripts/${i}" || die "failed to install ${i} script"
		insinto /etc/ppp/${i}.d
		use ipv6 && dosym ${i} /etc/ppp/${i/ip/ipv6}
		doins "${WORKDIR}/scripts/${i}.d"/* || die "failed to install ${i}.d scripts"
	done

	pamd_mimic_system ppp auth account session

	local PLUGINS_DIR=/usr/$(get_libdir)/pppd/$(awk -F '"' '/VERSION/ {print $2}' pppd/patchlevel.h)
	#closing " for syntax coloring
	insinto "${PLUGINS_DIR}"
	insopts -m0755
	doins pppd/plugins/minconn.so || die "minconn.so not build"
	doins pppd/plugins/passprompt.so || die "passprompt.so not build"
	doins pppd/plugins/passwordfd.so || die "passwordfd.so not build"
	doins pppd/plugins/winbind.so || die "winbind.so not build"
	doins pppd/plugins/rp-pppoe/rp-pppoe.so || die "rp-pppoe.so not build"
	if use atm; then
		doins pppd/plugins/pppoatm/pppoatm.so || die "pppoatm.so not build"
	fi
	if use dhcp; then
		doins pppd/plugins/dhcp/dhcpc.so || die "dhcpc.so not build"
	fi
	if use radius; then
		doins pppd/plugins/radius/radius.so || die "radius.so not build"
		doins pppd/plugins/radius/radattr.so || die "radattr.so not build"
		doins pppd/plugins/radius/radrealms.so || die "radrealms.so not build"

		#Copy radiusclient configuration files (#92878)
		insinto /etc/ppp/radius
		insopts -m0644
		doins pppd/plugins/radius/etc/{dictionary*,issue,port-id-map,radiusclient.conf,realms,servers}

		doman pppd/plugins/radius/pppd-radius.8
		doman pppd/plugins/radius/pppd-radattr.8
	fi

	insinto /etc/modprobe.d
	insopts -m0644
	newins "${FILESDIR}/modules.ppp" ppp.conf
	if use mppe-mppc; then
		sed -i -e 's/ppp_mppe/ppp_mppe_mppc/' "${D}/etc/modprobe.d/ppp.conf"
	fi

	dodoc PLUGINS README* SETUP Changes-2.3 FAQ
	dodoc "${FILESDIR}/README.mpls"

	dosbin scripts/pon && \
	    dosbin scripts/poff && \
	    dosbin scripts/plog && \
	    doman scripts/pon.1 || die "failed to install pon&poff scripts"

	# Adding misc. specialized scripts to doc dir
	insinto /usr/share/doc/${PF}/scripts/chatchat
	doins scripts/chatchat/* || die "failed to install chat scripts in doc dir"
	insinto /usr/share/doc/${PF}/scripts
	doins scripts/* || die "failed to install scripts in doc dir"

	if use gtk; then
		dosbin contrib/pppgetpass/{pppgetpass.vt,pppgetpass.gtk}
		newsbin contrib/pppgetpass/pppgetpass.sh pppgetpass
	else
		newsbin contrib/pppgetpass/pppgetpass.vt pppgetpass
	fi
	doman contrib/pppgetpass/pppgetpass.8
}

pkg_postinst() {
	if linux-info_get_any_version && linux_config_src_exists; then
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
		CONFIG_CHECK="${CONFIG_CHECK} ~PPP_DEFLATE ~PPP_BSDCOMP"
		local ERROR_PPP_DEFLATE="CONFIG_PPP_DEFLATE:\t missing Deflate compression (optional, but highly recommended)"
		local ERROR_PPP_BSDCOMP="CONFIG_PPP_BSDCOMP:\t missing BSD-Compress compression (optional, but highly recommended)"
		if use mppe-mppc ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~PPP_MPPE_MPPC"
			local WARNING_PPP_MPPE_MPPC="CONFIG_PPP_MPPE_MPPC:\t missing MPPE/MPPC encryption/compression (optional, mostly used by PPTP links)"
		else
			CONFIG_CHECK="${CONFIG_CHECK} ~PPP_MPPE"
			local WARNING_PPP_MPPE="CONFIG_PPP_MPPE:\t missing MPPE encryption (optional, mostly used by PPTP links)"
		fi
		CONFIG_CHECK="${CONFIG_CHECK} ~PPPOE ~PACKET"
		local WARNING_PPPOE="CONFIG_PPPOE:\t missing PPPoE support (optional, needed by rp-pppoe plugin)"
		local WARNING_PACKET="CONFIG_PACKET:\t missing AF_PACKET support (optional, used by rp-pppoe and dhcpc plugins)"
		if use atm ; then
			CONFIG_CHECK="${CONFIG_CHECK} ~PPPOATM"
			local WARNING_PPPOATM="CONFIG_PPPOATM:\t missing PPPoA support (optional, needed by pppoatm plugin)"
		fi
		check_extra_config
	fi

	if [ ! -e "${ROOT}/dev/.devfsd" ] && [ ! -e "${ROOT}/dev/.udev" ] && [ ! -e "${ROOT}/dev/ppp" ]; then
		mknod "${ROOT}/dev/ppp" c 108 0
	fi
	if [ "$ROOT" = "/" ]; then
		if [ -x /sbin/update-modules ]; then
			/sbin/update-modules
		else
			/sbin/modules-update
		fi
	fi

	# create *-secrets files if not exists
	[ -f "${ROOT}/etc/ppp/pap-secrets" ] || \
		cp -pP "${ROOT}/etc/ppp/pap-secrets.example" "${ROOT}/etc/ppp/pap-secrets"
	[ -f "${ROOT}/etc/ppp/chap-secrets" ] || \
		cp -pP "${ROOT}/etc/ppp/chap-secrets.example" "${ROOT}/etc/ppp/chap-secrets"

	# lib name has changed
	sed -i -e "s:^pppoe.so:rp-pppoe.so:" "${ROOT}/etc/ppp/options"

	if use radius && [[ $previous_less_than_2_4_3_r5 = 0 ]] ; then
		echo
		ewarn "As of ${PN}-2.4.3-r5, the RADIUS configuration files have moved from"
		ewarn "   /etc/radiusclient to /etc/ppp/radius."
		einfo "For your convenience, radiusclient directory was copied to the new location."
	fi

	echo
	elog "Pon, poff and plog scripts have been supplied for experienced users."
	elog "Users needing particular scripts (ssh,rsh,etc.) should check out the"
	elog "/usr/share/doc/${PF}/scripts directory."

	# move the old user-defined files into ip-{up,down}.d directories
	# TO BE REMOVED AFTER SEPT 2008
	local i
	for i in ip-up ip-down; do
		if [ -f "${ROOT}"/etc/ppp/${i}.local ]; then
			mv /etc/ppp/${i}.local /etc/ppp/${i}.d/90-local.sh && \
				ewarn "/etc/ppp/${i}.local has been moved to /etc/ppp/${i}.d/90-local.sh"
		fi
	done
}
