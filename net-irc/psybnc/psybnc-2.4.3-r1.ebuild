# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PV="$(ver_rs 3 -)"
PSYBNC_HOME="/var/lib/psybnc"

DESCRIPTION="A multi-user and multi-server gateway to IRC networks"
HOMEPAGE="http://www.psybnc.at/index.html"
SRC_URI="http://psybnc.org/download/psyBNC-${PV}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="ipv6 ssl oidentd scripting multinetwork"

DEPEND="
	acct-group/psybnc
	acct-user/psybnc
	net-dns/c-ares
	ssl? ( >=dev-libs/openssl-0.9.7d:= )
	oidentd? ( >=net-misc/oidentd-2.0 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.3-Fix-build-with-Clang-16.patch
	"${FILESDIR}"/${PN}-2.4.3-strmncpy-lto-mismatch.patch
)

src_unpack() {
	unpack ${A}
	cd "${S}" || die

	# Useless files
	rm -f */INFO || die

	# Pretend we already have a certificate, we generate it in pkg_config
	touch key/psybnc.cert.pem || die

	if [[ -f "${EPREFIX}"/usr/share/psybnc/salt.h ]]; then
		einfo "Using existing salt.h for password encryption"
		cp "${EPREFIX}"/usr/share/psybnc/salt.h salt.h || die
	fi
}

src_prepare() {
	default

	# Add oidentd
	use oidentd && PATCHES+=( "${FILESDIR}"/${P}-oidentd.patch )

	# Add scripting support
	use scripting && PATCHES+=( "${FILESDIR}"/${P}-scripting.patch )

	# Add multinetwork support
	use multinetwork && PATCHES+=( "${FILESDIR}"/${P}-multinetwork.patch )

	# Prevent stripping the binary
	sed -i -e "/@strip/ d" tools/autoconf.c || die
}

src_compile() {
	if use ipv6; then
		rm -f tools/chkipv6.c || die
	fi

	if use ssl; then
		rm -f tools/chkssl.c || die
	fi

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin psybnc

	insinto /usr/share/psybnc
	doins -r help lang salt.h
	fperms 0600 /usr/share/psybnc/salt.h

	insinto /etc/psybnc
	doins "${FILESDIR}"/psybnc.conf

	keepdir "${PSYBNC_HOME}"/{log,motd,scripts}
	dosym ../../../usr/share/psybnc/lang "${PSYBNC_HOME}"/lang
	dosym ../../../usr/share/psybnc/help "${PSYBNC_HOME}"/help

	fowners psybnc:psybnc "${PSYBNC_HOME}"/{,log,motd,scripts} /etc/psybnc/psybnc.conf
	fperms 0750 "${PSYBNC_HOME}"/{,log,motd,scripts}
	fperms 0640 /etc/psybnc/psybnc.conf

	if use ssl; then
		keepdir /etc/psybnc/ssl
		dosym ../../../etc/psybnc/ssl "${PSYBNC_HOME}"/key
	else
		# Drop SSL listener from psybnc.conf
		sed -i -e "/^# Default SSL listener$/,+4 d" "${D}"/etc/psybnc/psybnc.conf || die
	fi

	if use oidentd; then
		insinto /etc
		doins "${FILESDIR}"/oidentd.conf.psybnc
		fperms 640 /etc/oidentd.conf.psybnc
		# Install init-script with oidentd-support
		newinitd "${FILESDIR}"/psybnc-oidentd.initd psybnc
	else
		# Install init-script without oidentd-support
		newinitd "${FILESDIR}"/psybnc.initd psybnc
	fi

	if use scripting ; then
		dodoc SCRIPTING
	fi

	newconfd "${FILESDIR}"/psybnc.confd psybnc

	dodoc CHANGES FAQ README TODO
	docinto example-script
	dodoc scripts/example/DEFAULT.SCRIPT
}

pkg_config() {
	if use ssl; then
		if [[ -f "${EROOT}"/etc/psybnc/ssl/psybnc.cert.pem || -f "${EROOT}"/etc/psybnc/ssl/psybnc.key.pem ]]; then
			ewarn "Existing /etc/psybnc/psybnc.cert.pem or /etc/psybnc/psybnc.key.pem found!"
			ewarn "Remove /etc/psybnc/psybnc.*.pem and run emerge --config =${CATEGORY}/${PF} again."
			return
		fi

		einfo "Generating certificate request..."
		openssl req -new -out "${ROOT}"/etc/psybnc/ssl/psybnc.req.pem \
			-keyout "${ROOT}"/etc/psybnc/ssl/psybnc.key.pem -nodes || die

		einfo "Generating self-signed certificate..."
		openssl req -x509 -days 365 -in "${ROOT}"/etc/psybnc/ssl/psybnc.req.pem \
			-key "${ROOT}"/etc/psybnc/ssl/psybnc.key.pem \
			-out "${ROOT}"/etc/psybnc/ssl/psybnc.cert.pem || die

		einfo "Setting permissions on files..."
		chown root:psybnc "${ROOT}"/etc/psybnc/ssl/psybnc.{cert,key,req}.pem || die
		chmod 0640 "${ROOT}"/etc/psybnc/ssl/psybnc.{cert,key,req}.pem || die
	fi
}

pkg_postinst() {
	if use ssl; then
		elog
		elog "Please run \"emerge --config =${CATEGORY}/${PF}\" to create the needed SSL certificates."
	fi

	if use oidentd; then
		elog
		elog "You have enabled oidentd-support. You will need to set"
		elog "up your ${EROOT}/etc/oident.conf file before running psybnc. An example"
		elog "for psyBNC can be found under ${EROOT}/etc/oidentd.conf.psybnc"
	fi

	elog
	elog "You can connect to psyBNC on port 23998 with user gentoo and password gentoo."
	elog "Please edit the psyBNC configuration at ${EROOT}/etc/psybnc/psybnc.conf to change this."
	elog
	elog "To be able to reuse an existing psybnc.conf, you need to make sure that the"
	elog "old salt.h is available at ${EROOT}/usr/share/psybnc/salt.h when compiling a new"
	elog "version of psyBNC. It is needed for password encryption and decryption."
	elog
}
