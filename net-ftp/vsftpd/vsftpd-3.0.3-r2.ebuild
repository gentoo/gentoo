# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils systemd toolchain-funcs

DESCRIPTION="Very Secure FTP Daemon written with speed, size and security in mind"
HOMEPAGE="http://vsftpd.beasts.org/"
SRC_URI="http://security.appspot.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86"
IUSE="caps libressl pam tcpd ssl selinux xinetd"

DEPEND="caps? ( >=sys-libs/libcap-2 )
	pam? ( sys-libs/pam )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
RDEPEND="${DEPEND}
	net-ftp/ftpbase
	selinux? ( sec-policy/selinux-ftp )
	xinetd? ( sys-apps/xinetd )"

src_prepare() {
	# kerberos patch. bug #335980
	epatch "${FILESDIR}/${PN}-2.3.2-kerberos.patch"

	# Patch the source, config and the manpage to use /etc/vsftpd/
	epatch "${FILESDIR}/${PN}-2.3.5-gentoo.patch"

	# Fix building without the libcap
	epatch "${FILESDIR}/${PN}-2.1.0-caps.patch"

	# Fix building on alpha. Bug #405829
	epatch "${FILESDIR}/${PN}-3.0.2-alpha.patch"

	# Configure vsftpd build defaults
	use tcpd && echo "#define VSF_BUILD_TCPWRAPPERS" >> builddefs.h
	use ssl && echo "#define VSF_BUILD_SSL" >> builddefs.h
	use pam || echo "#undef VSF_BUILD_PAM" >> builddefs.h

	# Ensure that we don't link against libcap unless asked
	if ! use caps ; then
		sed -i '/^#define VSF_SYSDEP_HAVE_LIBCAP$/ d' sysdeputil.c || die
		epatch "${FILESDIR}"/${PN}-2.2.0-dont-link-caps.patch
	fi

	# Let portage control stripping
	sed -i '/^LINK[[:space:]]*=[[:space:]]*/ s/-Wl,-s//' Makefile || die

	#Bug #335977
	epatch "${FILESDIR}"/${PN}-3.0.0-Makefile.patch

	#Bug #450536
	epatch "${FILESDIR}"/${PN}-3.0.2-remove-legacy-cap.patch

	#Bug #630704
	epatch "${FILESDIR}"/${PN}-3.0.3-sparc.patch

	eapply_user
}

src_compile() {
	# Override LIBS variable. Bug #508192
	LIBS=
	use caps && LIBS+=" -lcap"
	use pam && LIBS+=" -lpam"
	use tcpd && LIBS+=" -lwrap"
	use ssl && LIBS+=" -lssl -lcrypto"

	CFLAGS="${CFLAGS}" \
	CC="$(tc-getCC)" \
	emake LIBS="${LIBS}"
}

src_install() {
	into /usr
	doman ${PN}.conf.5 ${PN}.8
	dosbin ${PN}

	dodoc AUDIT BENCHMARKS BUGS Changelog FAQ \
		README README.security REWARD SIZE \
		SPEED TODO TUNING || die "dodoc failed"
	newdoc ${PN}.conf ${PN}.conf.example

	docinto security
	dodoc SECURITY/*

	insinto "/usr/share/doc/${PF}/examples"
	doins -r EXAMPLE/*

	insinto /etc/${PN}
	newins ${PN}.conf{,.example}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use xinetd ; then
		insinto /etc/xinetd.d
		newins "${FILESDIR}/${PN}.xinetd" ${PN}
	fi

	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /usr/share/${PN}/empty

	exeinto /usr/libexec
	doexe "${FILESDIR}/vsftpd-checkconfig.sh"
	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}_at.service" "${PN}@.service"
	systemd_dounit "${FILESDIR}/${PN}.socket"
}

pkg_preinst() {
	# If we use xinetd, then we set listen=NO
	# so that our default config works under xinetd - fixes #78347
	if use xinetd ; then
		sed -i 's/listen=YES/listen=NO/g' "${D}"/etc/${PN}/${PN}.conf.example
	fi
}

pkg_postinst() {
	einfo "vsftpd openRC init script can now be multiplexed."
	einfo "The default init script forces /etc/vsftpd/vsftpd.conf to exist."
	einfo "If you symlink the init script to another one, say vsftpd.foo"
	einfo "then that uses /etc/vsftpd/foo.conf instead."
	einfo
	einfo "Example:"
	einfo "   cd /etc/init.d"
	einfo "   ln -s vsftpd vsftpd.foo"
	einfo "You can now treat vsftpd.foo like any other service"
}
