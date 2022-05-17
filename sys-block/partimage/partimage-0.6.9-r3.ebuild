# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic pam

DESCRIPTION="Console-based application to efficiently save raw partition data to image file"
HOMEPAGE="https://www.partimage.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~riscv ~sparc x86"
IUSE="nls nologin pam ssl static"
REQUIRED_USE="static? ( !pam )"

COMMON_DEPEND="
	acct-group/partimag
	acct-user/partimag
"
LIBS_DEPEND="
	app-arch/bzip2
	>=dev-libs/newt-0.52
	>=sys-libs/slang-2
	sys-libs/zlib:=
	!nologin? ( virtual/libcrypt:= )
	ssl? ( dev-libs/openssl:0= )
"
PAM_DEPEND="pam? ( sys-libs/pam )"
RDEPEND="
	${COMMON_DEPEND}
	${PAM_DEPEND}
	!static? ( ${LIBS_DEPEND} )
"
DEPEND="
	${PAM_DEPEND}
	${LIBS_DEPEND}
"
BDEPEND="
	${COMMON_DEPEND}
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.9-zlib-1.2.5.2-r1.patch #405323
	"${FILESDIR}"/${PN}-0.6.9-minor-typo.patch #580290
	"${FILESDIR}"/${PN}-0.6.9-openssl-1.1-compatibility.patch
	"${FILESDIR}"/${PN}-0.6.9-missing-includes.patch
	"${FILESDIR}"/${PN}-0.6.9-clang.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# XXX: Do we still need these?
	filter-flags -fno-exceptions
	use ppc && append-flags -fsigned-char

	local myeconfargs=(
		$(use_enable nls)
		$(usex nologin '--disable-login' '')
		$(use_enable pam)
		$(use_enable ssl)
		$(use_enable static all-static)
		--with-log-dir="${EPREFIX}"/var/log/partimage
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	keepdir /var/lib/partimage
	keepdir /var/log/partimage

	newinitd "${FILESDIR}"/partimaged.init.2 partimaged
	newconfd "${FILESDIR}"/partimaged.conf partimaged

	if use pam; then
		newpamd "${FILESDIR}"/partimaged.pam.2 partimaged
	fi

	if use ssl; then
		insinto /etc/partimaged
		doins "${FILESDIR}"/servercert.cnf
	fi

	fowners partimag:root /etc/partimaged/partimagedusers
}

pkg_config() {
	if use ssl; then
		local confdir="${EROOT}"/etc/partimaged
		local privkey="${confdir}"/partimaged.key
		local cnf="${confdir}"/servercert.cnf
		local csr="${confdir}"/partimaged.csr
		local cert="${confdir}"/partimaged.cert

		ewarn "Please customize /etc/partimaged/servercert.cnf before you continue!"
		ewarn "Press Ctrl-C to break now for it, or press enter to continue."
		read
		if [ ! -f "${privkey}" ]; then
			einfo "Generating unencrypted private key: ${privkey}"
			openssl genrsa -out "${privkey}" 2048 || die
		else
			einfo "Private key already exists: ${privkey}"
		fi
		if [ ! -f "${csr}" ]; then
			einfo "Generating certificate request: ${csr}"
			openssl req -new -x509 -outform PEM -out "${csr}" -key "${privkey}" -config "${cnf}" || die
		else
			einfo "Certificate request already exists: ${csr}"
		fi
		if [ ! -f "${cert}" ]; then
			einfo "Generating self-signed certificate: ${cert}"
			openssl x509 -in "${csr}" -out "${cert}" -signkey "${privkey}" || die
		else
			einfo "Self-signed certifcate already exists: ${cert}"
		fi
		einfo "Setting permissions"
		chmod 600 "${privkey}" || die
		chown partimag:root "${privkey}" || die
		chmod 644 "${cert}" "${csr}" || die
		chown root:root "${cert}" "${csr}" || die
		einfo "Done"
	else
		einfo "SSL is disabled, not building certificates"
	fi
}

pkg_postinst() {
	if use ssl; then
		einfo "To create the required SSL certificates, please do:"
		einfo "emerge --config =${PF}"
	fi
}
