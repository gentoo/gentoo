# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit autotools eutils multilib python-single-r1 udev systemd

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
	#COMMIT="9ca7e469cf115469f392db7436816151867e1654"
	#SRC_URI="https://github.com/kismetwireless/kismet/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	#S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="amd64 arm ~arm64 ~ppc x86"
fi

DESCRIPTION="IEEE 802.11 wireless LAN sniffer"
HOMEPAGE="https://www.kismetwireless.net"

LICENSE="GPL-2"
SLOT="0/${PV}"
IUSE="libusb lm-sensors networkmanager +pcre rtlsdr selinux +suid ubertooth udev"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

CDEPEND="
	${PYTHON_DEPS}
	acct-user/kismet
	acct-group/kismet
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
	libusb? ( virtual/libusb:1 )
	dev-libs/protobuf-c:=
	dev-libs/protobuf:=
	$(python_gen_cond_dep '
		dev-python/protobuf-python[${PYTHON_MULTI_USEDEP}]
	')
	sys-libs/ncurses:=
	lm-sensors? ( sys-apps/lm-sensors )
	pcre? ( dev-libs/libpcre )
	suid? ( sys-libs/libcap )
	ubertooth? ( net-wireless/ubertooth:= )
	"

DEPEND="${CDEPEND}
	virtual/pkgconfig
"

RDEPEND="${CDEPEND}
	$(python_gen_cond_dep '
		dev-python/pyserial[${PYTHON_MULTI_USEDEP}]
	')
	selinux? ( sec-policy/selinux-kismet )
"
PDEPEND="
	rtlsdr? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_MULTI_USEDEP}]
		')
		net-wireless/rtl-sdr
	)"

src_prepare() {
	sed -i -e "s:^\(logtemplate\)=\(.*\):\1=/tmp/\2:" \
		conf/kismet_logging.conf || die

	#this was added to quiet macosx builds but it makes gcc builds noisier
	sed -i -e 's#-Wno-unknown-warning-option ##g' Makefile.inc.in || die

	#sed -i -e 's#root#kismet#g' packaging/systemd/kismet.service.in

	# Don't strip and set correct mangrp
	sed -i -e 's| -s||g' \
		-e 's|@mangrp@|root|g' Makefile.in || die

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
		$(use_enable libusb libusb) \
		$(use_enable pcre) \
		$(use_enable lm-sensors lmsensors) \
		$(use_enable networkmanager libnm) \
		$(use_enable ubertooth) \
		--sysconfdir=/etc/kismet \
		--disable-optimization
}

src_install() {
	emake DESTDIR="${D}" commoninstall
	python_optimize
	emake DESTDIR="${D}" forceconfigs
	use udev && udev_dorules packaging/udev/*.rules

	insinto /usr/share/${PN}
	doins Makefile.inc

	dodoc CHANGELOG README*
	newinitd "${FILESDIR}"/${PN}.initd-r3 kismet
	newconfd "${FILESDIR}"/${PN}.confd-r2 kismet
	systemd_dounit packaging/systemd/kismet.service
}

pkg_preinst() {
	if use suid; then
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

migrate_config() {
	einfo "Kismet Configuration files are now read from /etc/kismet/"
	ewarn "Please keep user specific settings in /etc/kismet/kismet_site.conf"
	if [ -n "$(ls ${EROOT}/etc/kismet_*.conf 2> /dev/null)" ]; then
		ewarn "Files at /etc/kismet_*.conf will not be read and should be removed"
	fi
	if [ -f "${EROOT}/etc/kismet_site.conf" ] && [ ! -f "${EROOT}/etc/kismet/kismet_site.conf" ]; then
		mv /etc/kismet_site.conf /etc/kismet/kismet_site.conf || die "Failed to migrate kismet_site.conf to new location"
		ewarn "Your /etc/kismet_site.conf file has been automatically moved to /etc/kismet/kismet_site.conf"
	elif [ -f "${EROOT}/etc/kismet_site.conf" ] && [ -f "${EROOT}/etc/kismet/kismet_site.conf" ]; then
		ewarn "Both /etc/kismet_site.conf and /etc/kismet/kismet_site.conf exist, please migrate needed bits"
		ewarn "into /etc/kismet/kismet_site.conf and remove /etc/kismet_site.conf"
	fi
}

pkg_postinst() {
	if [ -n "${REPLACING_VERSIONS}" ]; then
		for v in ${REPLACING_VERSIONS}; do
			if ver_test ${v} -lt 2019.07.2 ; then
				migrate_config
				break
			fi
			if ver_test ${v} -eq 9999 ; then
				migrate_config
				break
			fi
		done
	fi
}
