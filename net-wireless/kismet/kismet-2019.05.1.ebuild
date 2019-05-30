# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib user python-single-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://www.kismetwireless.net/git/${PN}.git"
	inherit git-r3
	RESTRICT="strip"
else
	MY_P=${P/\./-}
	MY_P=${MY_P/_beta/-BETA}
	MY_P=${MY_P/./-R}
	S=${WORKDIR}/${MY_P/BETA/beta}

	#normally we want an official release
	SRC_URI="https://www.kismetwireless.net/code/${MY_P}.tar.xz"

	#but sometimes we want a git commit
	#COMMIT="6d6d486831c0f7ac712ffb8a3ff122c5063c3b2a"
	#SRC_URI="https://github.com/kismetwireless/kismet/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	#S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="amd64 arm ~arm64 ~ppc x86"
fi

DESCRIPTION="IEEE 802.11 wireless LAN sniffer"
HOMEPAGE="https://www.kismetwireless.net"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="lm_sensors mousejack networkmanager +pcre selinux +suid"

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
	mousejack? ( dev-libs/libusb:= )
	dev-libs/protobuf-c:=
	dev-libs/protobuf:=
	dev-python/protobuf-python[${PYTHON_USEDEP}]
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

	eapply_user

	#just use set to fix setup.py
	find . -name "Makefile.in" -exec sed -i 's#setup.py install#setup.py install --root=$(DESTDIR)#' {} + || die
	find . -name "Makefile" -exec sed -i 's#setup.py install#setup.py install --root=$(DESTDIR)#' {} + || die

	if [ "${PV}" = "9999" ]; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		$(use_enable pcre) \
		$(use_enable lm_sensors lmsensors) \
		$(use_enable mousejack libusb) \
		$(use_enable networkmanager libnm) \
		--disable-optimization
}

src_install() {
	emake DESTDIR="${D}" commoninstall
	emake DESTDIR="${D}" forceconfigs

	insinto /usr/share/${PN}
	doins Makefile.inc

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
