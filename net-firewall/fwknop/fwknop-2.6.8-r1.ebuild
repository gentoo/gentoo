# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1
DISABLE_AUTOFORMATTING=1

DISTUTILS_OPTIONAL=1
# Python extension supports only Python2
# See https://github.com/mrash/fwknop/issues/167
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils eutils distutils-r1 linux-info readme.gentoo-r1 systemd

DESCRIPTION="Single Packet Authorization and Port Knocking application"
HOMEPAGE="http://www.cipherdyne.org/fwknop/ https://github.com/mrash/fwknop"
SRC_URI="https://github.com/mrash/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client extras firewalld gdbm gpg iptables python server udp-server"

DEPEND="
	client? ( net-misc/wget[ssl] )
	firewalld? ( net-firewall/firewalld[${PYTHON_USEDEP}] )
	gdbm? ( sys-libs/gdbm )
	gpg? (
		app-crypt/gpgme
		dev-libs/libassuan
		dev-libs/libgpg-error
	)
	iptables? ( net-firewall/iptables )
	python? ( ${PYTHON_DEPS} )
	server? ( !udp-server? ( net-libs/libpcap ) )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	firewalld? ( server )
	iptables? ( server )
	server? ( ^^ ( firewalld iptables ) )
	udp-server? ( server )
"

DOCS=( ChangeLog README.md )

DOC_CONTENTS="
Example configuration files were installed in /etc/fwknopd directory.
Please edit them to fit your needs and then remove the .example suffix.

fwknopd supports several backends: firewalld, iptables, ipfw, pf, ipf.
You can set the desired backend via FIREWALL_EXE option in fwknopd.conf
instead of the default one chosen at compile time.
"

pkg_pretend() {
	if use server; then
		if ! linux_config_exists || ! linux_chkconfig_present NETFILTER_XT_MATCH_COMMENT; then
			ewarn "fwknopd uses the iptables 'comment' match to expire SPA rules,"
			ewarn "which is a major security feature and is enabled by default."
			ewarn "Please either enable NETFILTER_XT_MATCH_COMMENT support in your"
			ewarn "kernel, or set the appropriate ENABLE_{FIREWD,IPT}_COMMENT_CHECK"
			ewarn "to 'N' in your fwknopd.conf file."
		fi
	fi
}

src_prepare() {
	# Install example configs with .example suffix
	if use server; then
		sed -i -e 's/conf;/conf.example;/g' "${S}"/Makefile.am || die
	fi

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/run
		--enable-digest-cache
		$(use_enable client)
		$(use_enable !gdbm file-cache)
		$(use_enable server)
		$(use_enable udp-server)
		$(use_with gpg gpgme)
	)
	use firewalld && myeconfargs+=(--with-firewalld=/usr/sbin/firewalld)
	use iptables && myeconfargs+=(--with-iptables=/sbin/iptables)

	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile

	if use python; then
		cd "${S}"/python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	autotools-utils_src_install
	prune_libtool_files --modules

	if use server; then
		newinitd "${FILESDIR}/fwknopd.init" fwknopd
		newconfd "${FILESDIR}/fwknopd.confd" fwknopd
		systemd_dounit extras/systemd/fwknopd.service
		systemd_newtmpfilesd extras/systemd/fwknopd.tmpfiles.conf fwknopd.conf
		readme.gentoo_create_doc
	fi

	use extras && dodoc "${S}/extras/apparmor/usr.sbin.fwknopd"

	if use python; then
		# Unset DOCS since distutils-r1.eclass interferes
		local DOCS=()
		cd "${S}"/python || die
		distutils-r1_src_install
	fi
}

pkg_postinst() {
	use server && readme.gentoo_print_elog
}
