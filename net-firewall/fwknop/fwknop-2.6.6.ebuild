# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/fwknop/fwknop-2.6.6.ebuild,v 1.2 2015/05/01 04:45:42 idella4 Exp $

EAPI=5

# Does work with python2_7, does not work with python3_3 on my machine
# More feedback is welcome, since setup.py does not provide any info
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1
DISTUTILS_SINGLE_IMPL=1
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils distutils-r1 systemd

DESCRIPTION="Single Packet Authorization and Port Knocking application"
HOMEPAGE="http://www.cipherdyne.org/fwknop/"
SRC_URI="https://github.com/mrash/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="client extras gdbm gpg python server udp-server"

RDEPEND="
	client? ( net-misc/wget[ssl] )
	gpg? (
		dev-libs/libassuan
		dev-libs/libgpg-error
	)
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	gdbm? ( sys-libs/gdbm )
	gpg? ( app-crypt/gpgme )
	server? (
		!udp-server? ( net-libs/libpcap )
		net-firewall/iptables
	)
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	udp-server? ( server )
"

DOCS=( ChangeLog README.md )

src_prepare() {
	# Install example configs with .example suffix
	if use server; then
		sed -i 's/conf;/conf.example;/g' "${S}"/Makefile.am || die
	fi

	autotools-utils_src_prepare

	if use python; then
		cd "${S}"/python || die
		distutils-r1_src_prepare
	fi
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
		systemd_newtmpfilesd "${FILESDIR}/fwknopd.tmpfiles.conf" fwknopd.conf
	fi

	use extras && dodoc "${S}/extras/apparmor/usr.sbin.fwknopd"

	if use python; then
		# Unset DOCS since distutils-r1.eclass interferes
		local DOCS=()
		cd "${S}"/python || die
		distutils-r1_src_install
	fi
}
