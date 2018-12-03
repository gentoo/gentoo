# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib user python-single-r1

MY_P=${P/\./-}
MY_P=${MY_P/_beta/-BETA}
MY_P=${MY_P/./-R}
S=${WORKDIR}/${MY_P}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://www.kismetwireless.net/${PN}.git"
	SRC_URI=""
	inherit git-r3
	KEYWORDS=""
	RESTRICT="strip"
else
	SRC_URI="https://www.kismetwireless.net/code/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
fi

DESCRIPTION="IEEE 802.11 wireless LAN sniffer"
HOMEPAGE="https://www.kismetwireless.net"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="lm_sensors networkmanager +pcre selinux +suid"

CDEPEND="
	${PYTHON_DEPS}
	networkmanager? ( net-misc/networkmanager:= )
	dev-libs/glib:=
	dev-libs/elfutils:=
	sys-libs/zlib:=
	dev-db/sqlite:=
	net-libs/libmicrohttpd
	kernel_linux? ( sys-libs/libcap
			dev-libs/libnl:3
			net-libs/libpcap
			)
	dev-libs/libusb:=
	dev-libs/protobuf-c:=
	dev-libs/protobuf:=
	sys-libs/ncurses:=
	lm_sensors? ( sys-apps/lm_sensors )
	pcre? ( dev-libs/libpcre )
	suid? ( sys-libs/libcap )
	"

DEPEND="${CDEPEND}
	virtual/pkgconfig
"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-kismet )
"

src_prepare() {
	sed -i -e "s:^\(logtemplate\)=\(.*\):\1=/tmp/\2:" \
		conf/kismet_logging.conf || die

	# Don't strip and set correct mangrp
	sed -i -e 's| -s||g' \
		-e 's|@mangrp@|root|g' Makefile.in

	epatch "${FILESDIR}"/fix-setuptools3.patch
	eapply_user

	if use lm_sensors; then
		sed -i "s#HAVE_LMSENSORS_H=0#HAVE_LMSENSORS_H=1#" configure.ac || die
		sed -i "s#HAVE_LIBLMSENSORS=0#HAVE_LMSENSORS=1#" configure.ac || die
	else
		sed -i "s#HAVE_LMSENSORS_H=1#HAVE_LMSENSORS_H=0#" configure.ac || die
		sed -i "s#HAVE_LIBLMSENSORS=1#HAVE_LMSENSORS=0#" configure.ac || die
	fi
	#fix for bug #662726
	sed -i "s#HAVE_SENSORS_SENSORS_H#HAVE_LMSENSORS_H#" system_monitor.cc || die

	if use networkmanager; then
		sed -i "s#havelibnm\=no#havelibnm\=yes#" configure.ac || die
	else
		sed -i "s#havelibnm\=yes#havelibnm\=no#" configure.ac || die
	fi
	sed -i 's#-O3##' configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable pcre)
}

src_install() {
	emake DESTDIR="${D}" commoninstall
	emake DESTDIR="${D}" forceconfigs

	insinto /usr/share/${PN}
	doins -r log_tools

	#dodoc CHANGELOG RELEASENOTES.txt README* docs/DEVEL.client docs/README.newcore
	dodoc CHANGELOG README*
	newinitd "${FILESDIR}"/${PN}.initd kismet
	newconfd "${FILESDIR}"/${PN}.confd kismet
}

pkg_preinst() {
	if use suid; then
		enewgroup kismet
		fowners root:kismet /usr/bin/kismet_cap_linux_bluetooth
		fowners root:kismet /usr/bin/kismet_cap_linux_wifi
		fowners root:kismet /usr/bin/kismet_cap_pcapfile
		# Need to set the permissions after chowning.
		# See chown(2)
		fperms 4550 /usr/bin/kismet_cap_linux_bluetooth
		fperms 4550 /usr/bin/kismet_cap_linux_wifi
		fperms 4550 /usr/bin/kismet_cap_pcapfile
		elog "Kismet has been installed with a setuid-root helper binary"
		elog "to enable minimal-root operation.  Users need to be part of"
		elog "the 'kismet' group to perform captures from physical devices."
	fi
	if ! use suid; then
		ewarn "It is highly discouraged to run a sniffer as root,"
		ewarn "Please consider enabling the suid use flag and adding"
		ewarn "your user to the kismet group."
	fi
}
