# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils versionator toolchain-funcs flag-o-matic user
MY_PV="$(replace_version_separator 3 -)"
PSYBNC_HOME="/var/lib/psybnc"

DESCRIPTION="psyBNC is a multi-user and multi-server gateway to IRC networks"
HOMEPAGE="http://www.psybnc.at/index.html"
SRC_URI="http://www.psybnc.at/download/beta/psyBNC-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86 ~ppc"
IUSE="ipv6 ssl oidentd scripting multinetwork"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.7d )
		oidentd? ( >=net-misc/oidentd-2.0 )"
RDEPEND="${DEPEND}"
S="${WORKDIR}"/"${PN}"

pkg_setup() {
	enewgroup psybnc
	enewuser psybnc -1 -1 ${PSYBNC_HOME} psybnc
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Useless files
	rm -f */INFO

	# Pretend we already have a certificate, we generate it in pkg_config
	mkdir key
	touch key/psybnc.cert.pem

	if [[ -f ${ROOT}/usr/share/psybnc/salt.h ]]
	then
		einfo "Using existing salt.h for password encryption"
		cp "${ROOT}"/usr/share/psybnc/salt.h salt.h
	fi
}

src_prepare() {
	epatch "${FILESDIR}/compile.diff"
	epatch "${FILESDIR}/ldflags-fix.patch"

	# add oidentd
	use oidentd && epatch "${FILESDIR}/${P}-oidentd.patch"

	# add scripting support
	use scripting && epatch "${FILESDIR}/${P}-scripting.patch"

	# add multinetwork support
	use multinetwork && epatch "${FILESDIR}/${P}-multinetwork.patch"

	# Prevent stripping the binary
	sed -i -e "/@strip/ d" tools/autoconf.c
}

src_compile() {
	use ipv6 || rm -f tools/chkipv6.c
	use ssl || rm -f tools/chkssl.c

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	dobin psybnc

	insinto /usr/share/psybnc
	doins -r help lang salt.h
	fperms 0600 /usr/share/psybnc/salt.h

	insinto /etc/psybnc
	doins "${FILESDIR}"/psybnc.conf

	keepdir "${PSYBNC_HOME}"/{log,motd,scripts}
	dosym /usr/share/psybnc/lang "${PSYBNC_HOME}"/lang
	dosym /usr/share/psybnc/help "${PSYBNC_HOME}"/help

	fowners psybnc:psybnc "${PSYBNC_HOME}"/{,log,motd,scripts} /etc/psybnc/psybnc.conf
	fperms 0750 "${PSYBNC_HOME}"/{,log,motd,scripts}
	fperms 0640 /etc/psybnc/psybnc.conf

	if use ssl
	then
		keepdir /etc/psybnc/ssl
		dosym /etc/psybnc/ssl "${PSYBNC_HOME}"/key
	else
		# Drop SSL listener from psybnc.conf
		sed -i -e "/^# Default SSL listener$/,+4 d" "${D}"/etc/psybnc/psybnc.conf
	fi

	if use oidentd
	then
		insinto /etc
		doins "${FILESDIR}"/oidentd.conf.psybnc
		fperms 640 /etc/oidentd.conf.psybnc
		# install init-script with oidentd-support
		newinitd "${FILESDIR}"/psybnc-oidentd.initd psybnc
	else
		# install init-script without oidentd-support
		newinitd "${FILESDIR}"/psybnc.initd psybnc
	fi

	newconfd "${FILESDIR}"/psybnc.confd psybnc

	dodoc CHANGES FAQ README SCRIPTING TODO
	docinto example-script
	dodoc scripts/example/DEFAULT.SCRIPT
}

pkg_config() {
	if use ssl
	then
		if [[ -f ${ROOT}/etc/psybnc/ssl/psybnc.cert.pem || -f ${ROOT}/etc/psybnc/ssl/psybnc.key.pem ]]
		then
			ewarn "Existing /etc/psybnc/psybnc.cert.pem or /etc/psybnc/psybnc.key.pem found!"
			ewarn "Remove /etc/psybnc/psybnc.*.pem and run emerge --config =${CATEGORY}/${PF} again."
			return
		fi

		einfo "Generating certificate request..."
		openssl req -new -out "${ROOT}"/etc/psybnc/ssl/psybnc.req.pem -keyout "${ROOT}"/etc/psybnc/ssl/psybnc.key.pem -nodes
		einfo "Generating self-signed certificate..."
		openssl req -x509 -days 365 -in "${ROOT}"/etc/psybnc/ssl/psybnc.req.pem -key "${ROOT}"/etc/psybnc/ssl/psybnc.key.pem -out "${ROOT}"/etc/psybnc/ssl/psybnc.cert.pem
		einfo "Setting permissions on files..."
		chown root:psybnc "${ROOT}"/etc/psybnc/ssl/psybnc.{cert,key,req}.pem
		chmod 0640 "${ROOT}"/etc/psybnc/ssl/psybnc.{cert,key,req}.pem
	fi
}

pkg_postinst() {
	if use ssl
	then
		elog
		elog "Please run \"emerge --config =${CATEGORY}/${PF}\" to create needed SSL certificates."
	fi
	if use oidentd
	then
		elog
		elog "You have enabled oidentd-support. You will need to set"
		elog "up your /etc/oident.conf file before running psybnc. An example"
		elog "for psyBNC can be found under /etc/oidentd.conf.psybnc"
	fi
	elog
	elog "You can connect to psyBNC on port 23998 with user gentoo and password gentoo."
	elog "Please edit the psyBNC configuration at /etc/psybnc/psybnc.conf to change this."
	elog
	elog "To be able to reuse an existing psybnc.conf, you need to make sure that the"
	elog "old salt.h is available at /usr/share/psybnc/salt.h when compiling a new"
	elog "version of psyBNC. It is needed for password encryption and decryption."
	elog
}
