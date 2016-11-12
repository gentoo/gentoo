# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5} )
inherit eutils python-single-r1 readme.gentoo-r1 systemd user

MY_PV=${PV/_/-}
GTEST_VER="1.7.0"
GTEST_URL="https://googletest.googlecode.com/files/gtest-${GTEST_VER}.zip"
DESCRIPTION="An advanced IRC Bouncer"

SRC_URI="http://znc.in/releases/${PN}-${MY_PV}.tar.gz
	test? ( ${GTEST_URL} )"
KEYWORDS="amd64 arm x86"

HOMEPAGE="http://znc.in"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="daemon debug ipv6 libressl perl python ssl sasl tcl test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/icu:=
	sys-libs/zlib
	perl? ( >=dev-lang/perl-5.10 )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl )
	)
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${PN}-${MY_PV}

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-systemwideconfig.patch
	"${FILESDIR}"/${PN}-1.6.1-create-pidfile-per-default.patch
)

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	if use daemon; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
		# The home directory was previously set to /dev/null
		# This caused a bug with the systemd unit
		# https://bugs.gentoo.org/521916
		esethome ${PN} /var/lib/${PN}
	fi
}

src_configure() {
	econf \
		--with-systemdsystemunitdir=$(systemd_get_systemunitdir) \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable perl) \
		$(use_enable python) \
		$(use_enable sasl cyrus) \
		$(use_enable ssl openssl) \
		$(use_enable tcl tcl) \
		$(use_with test gtest "${WORKDIR}/gtest-${GTEST_VER}")
}

src_install() {
	emake install DESTDIR="${D%/}"
	dodoc NOTICE README.md
	if use daemon; then
		newinitd "${FILESDIR}"/znc.initd-r1 znc
		newconfd "${FILESDIR}"/znc.confd-r1 znc
	fi
	DOC_CONTENTS=$(<"${FILESDIR}/README.gentoo")
	DISABLE_AUTOFORMATTING=1
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	if [[ -d "${EROOT%/}"/etc/znc ]]; then
		ewarn "/etc/znc exists on your system."
		ewarn "Due to the nature of the contents of that folder,"
		ewarn "we have changed the default configuration to use"
		ewarn "	/var/lib/znc"
		ewarn "please move /etc/znc to /var/lib/znc"
		ewarn "or adjust /etc/conf.d/znc"
	fi
}

pkg_config() {
	if use daemon; then
		if [[ -e "${EROOT%/}/var/lib/znc" ]]; then
			ewarn "${EROOT%/}/var/lib/znc already exists, aborting to avoid damaging"
			ewarn "any existing configuration. If you are sure you want"
			ewarn "to generate a new configuration, remove the folder"
			ewarn "and try again."
		else
			einfo "Press any key to interactively create a new configuration file"
			einfo "for znc."
			einfo "To abort, press Control-C"
			read
			mkdir -p "${EROOT%/}/var/lib/znc" || die
			chown -R ${PN}:${PN} "${EROOT%/}/var/lib/znc" ||
				die "Setting permissions failed"
			"${EROOT%/}"/usr/bin/znc --system-wide-config-as ${PN} -c -r -d "${EROOT%/}/var/lib/znc" ||
				die "Config failed"
			echo
			einfo "To start znc, run '/etc/init.d/znc start'"
			einfo "or add znc to a runlevel:"
			einfo "  rc-update add znc default"
		fi
	else
		ewarn "To configure znc as a system-wide daemon you have to"
		ewarn "enable the 'daemon' use flag."
	fi
}
