# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Python extension supports only Python 2.
# See https://github.com/mrash/fwknop/issues/167
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit autotools distutils-r1 eutils linux-info readme.gentoo-r1 systemd

DESCRIPTION="Single Packet Authorization and Port Knocking application"
HOMEPAGE="https://www.cipherdyne.org/fwknop/ https://github.com/mrash/fwknop"
SRC_URI="https://github.com/mrash/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client extras firewalld gdbm gpg iptables nfqueue python server udp-server"

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
	nfqueue? ( net-libs/libnetfilter_queue )
	python? ( ${PYTHON_DEPS} )
	server? ( !nfqueue? ( !udp-server? ( net-libs/libpcap ) ) )
"
RDEPEND="${DEPEND}"

REQUIRED_USE="
	firewalld? ( server )
	gdbm? ( server )
	iptables? ( server )
	nfqueue? ( server )
	python? ( ${PYTHON_REQUIRED_USE} )
	server? ( ^^ ( firewalld iptables ) )
	udp-server? ( server )
"

DOCS=( AUTHORS ChangeLog README.md )

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="
Example configuration files were installed to '${EPREFIX}/etc/fwknopd/'.
Please edit them to suit your needs and then remove the .example suffix.

fwknopd supports several backends: firewalld, iptables, ipfw, pf, ipf.
You can set the desired backend via FIREWALL_EXE option in fwknopd.conf
instead of the default one chosen at compile time.
"

src_prepare() {
	default_src_prepare

	# Install example configs with .example suffix.
	if use server; then
		sed -i -e 's|conf;|conf.example;|g' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}/run"
		$(use_enable client)
		$(use_enable !gdbm file-cache)
		$(use_enable nfqueue nfq-capture)
		$(use_enable server)
		$(use_enable udp-server)
		$(use_with gpg gpgme)
	)
	use firewalld && myeconfargs+=(--with-firewalld="${EPREFIX}/usr/sbin/firewalld")
	use iptables && myeconfargs+=(--with-iptables="${EPREFIX}/sbin/iptables")

	econf "${myeconfargs[@]}"
}

src_compile() {
	default_src_compile

	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	default_src_install
	prune_libtool_files --modules

	if use extras; then
		dodoc extras/apparmor/usr.sbin.fwknopd
		dodoc extras/console-qr/console-qr.sh
		dodoc extras/fwknop-launcher/*
	fi

	if use server; then
		newinitd "${FILESDIR}/fwknopd.init" fwknopd
		newconfd "${FILESDIR}/fwknopd.confd" fwknopd
		systemd_dounit extras/systemd/fwknopd.service
		systemd_newtmpfilesd extras/systemd/fwknopd.tmpfiles.conf fwknopd.conf
		readme.gentoo_create_doc
	fi

	if use python; then
		# Redefine DOCS, otherwise distutils-r1 eclass interferes.
		local DOCS=()
		cd python || die
		distutils-r1_src_install
	fi
}

pkg_postinst() {
	if use server; then
		readme.gentoo_print_elog

		if ! linux_config_exists || ! linux_chkconfig_present NETFILTER_XT_MATCH_COMMENT; then
			echo
			ewarn "fwknopd daemon relies on the 'comment' match in order to expire"
			ewarn "created firewall rules, which is an important security feature."
			ewarn "Please enable NETFILTER_XT_MATCH_COMMENT support in your kernel."
			echo
		fi
		if use nfqueue && \
			! linux_config_exists || ! linux_chkconfig_present NETFILTER_XT_TARGET_NFQUEUE; then
			echo
			ewarn "fwknopd daemon relies on the 'NFQUEUE' target for NFQUEUE mode."
			ewarn "Please enable NETFILTER_XT_TARGET_NFQUEUE support in your kernel."
			echo
		fi
	fi
}
