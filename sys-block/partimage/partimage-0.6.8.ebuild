# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit autotools eutils flag-o-matic pam user

DESCRIPTION="Console-based application to efficiently save raw partition data to an image file"
HOMEPAGE="http://www.partimage.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="nls nologin pam ssl static"

LIBS_DEPEND="app-arch/bzip2
	>=dev-libs/newt-0.52
	>=sys-libs/slang-2
	sys-libs/zlib
	ssl? ( dev-libs/openssl )"
PAM_DEPEND="!static? ( pam? ( virtual/pam ) )"
RDEPEND="${PAM_DEPEND}
	!static? ( ${LIBS_DEPEND} )"
DEPEND="${PAM_DEPEND}
	${LIBS_DEPEND}
	nls? ( sys-devel/gettext )"

pkg_setup() {
	enewgroup partimag 91
	enewuser partimag 91 -1 /var/lib/partimage partimag
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-destdir.patch \
		"${FILESDIR}"/${P}-openssl-1.patch
	eautoreconf
}

src_configure() {
	# XXX: Do we still need these?
	filter-flags -fno-exceptions
	use ppc && append-flags -fsigned-char

	local myconf

	use nologin && myconf="${myconf} --disable-login"

	if use pam && ! use static; then
		myconf="${myconf} --enable-pam"
	fi

	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--sysconfdir="${EPREFIX}"/etc \
		$(use_enable nls) \
		--disable-dependency-tracking \
		$(use_enable ssl) \
		--disable-pam \
		$(use_enable static all-static) \
		--with-log-dir="${EPREFIX}"/var/log/partimage \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc BOOT-ROOT.txt FORMAT FUTURE THANKS
	prepalldocs

	keepdir /var/lib/partimage
	keepdir /var/log/partimage

	insinto /etc/partimaged
	doins "${FILESDIR}"/servercert.cnf || die

	newinitd "${FILESDIR}"/partimaged.init partimaged || die
	newconfd "${FILESDIR}"/partimaged.conf partimaged || die

	if use pam; then
		newpamd "${FILESDIR}"/partimaged.pam partimaged || die
	fi
}

confdir=${ROOT}etc/partimaged
privkey=${confdir}/partimaged.key
cnf=${confdir}/servercert.cnf
csr=${confdir}/partimaged.csr
cert=${confdir}/partimaged.cert

pkg_config() {
	if use ssl; then
		ewarn "Please customize /etc/partimaged/servercert.cnf before you continue!"
		ewarn "Press Ctrl-C to break now for it, or press enter to continue."
		read
		if [ ! -f ${privkey} ]; then
			einfo "Generating unencrypted private key: ${privkey}"
			openssl genrsa -out ${privkey} 1024  || die "Failed!"
		else
			einfo "Private key already exists: ${privkey}"
		fi
		if [ ! -f ${csr} ]; then
			einfo "Generating certificate request: ${csr}"
			openssl req -new -x509 -outform PEM -out ${csr} -key ${privkey} -config ${cnf} || die "Failed!"
		else
			einfo "Certificate request already exists: ${csr}"
		fi
		if [ ! -f ${cert} ]; then
			einfo "Generating self-signed certificate: ${cert}"
			openssl x509 -in ${csr} -out ${cert} -signkey ${privkey} || die "Failed!"
		else
			einfo "Self-signed certifcate already exists: ${cert}"
		fi
		einfo "Setting permissions"
		partimagesslperms || die "Failed!"
		einfo "Done"
	else
		einfo "SSL is disabled, not building certificates"
	fi
}

partimagesslperms() {
	local ret=0
	chmod 600 ${privkey} 2>/dev/null
	ret=$((${ret}+$?))
	chown partimag:0 ${privkey} 2>/dev/null
	ret=$((${ret}+$?))
	chmod 644 ${cert} ${csr} 2>/dev/null
	ret=$((${ret}+$?))
	chown root:0 ${cert} ${csr} 2>/dev/null
	ret=$((${ret}+$?))
	return $ret
}

pkg_postinst() {
	if use ssl; then
		einfo "To create the required SSL certificates, please do:"
		einfo "emerge  --config =${PF}"
		partimagesslperms
		return 0
	fi
	chown partimag:0 "${ROOT}"etc/partimaged/partimagedusers || die
}
