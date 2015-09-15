# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_3,3_4} )
inherit eutils python-single-r1 systemd user

MY_PV=${PV/_/-}
GTEST_VER="1.7.0"
GTEST_URL="https://googletest.googlecode.com/files/gtest-${GTEST_VER}.zip"
DESCRIPTION="An advanced IRC Bouncer"

SRC_URI="http://znc.in/releases/${PN}-${MY_PV}.tar.gz
	test? ( ${GTEST_URL} )"
KEYWORDS="~amd64 ~arm ~x86"

HOMEPAGE="http://znc.in"
LICENSE="GPL-2"
SLOT="0"
IUSE="daemon debug ipv6 perl python ssl sasl tcl test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/icu
	sys-libs/zlib
	perl? ( >=dev-lang/perl-5.10 )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( >=dev-libs/openssl-0.9.7d:0 )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	perl? (
		>=dev-lang/swig-2.0.12
	)
	python? (
		>=dev-lang/swig-2.0.12
	)
"

S=${WORKDIR}/${PN}-${MY_PV}

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-systemwideconfig.patch
	"${FILESDIR}"/${PN}-1.6.1-create-pidfile-per-default.patch
)

ZNC_DATADIR="${ZNC_DATADIR:-"/var/lib/znc"}"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	if use daemon; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /dev/null ${PN}
	fi
}

src_unpack() {
	default

	if use test; then
		cd "${S}"/test || die "Failed to chdir into '${S}/test'"
		unpack ${GTEST_URL##*/}
		mv gtest-${GTEST_VER} gtest \
			|| die "Failed to rename '${S}/test/gtest-${GTEST_VER}' dir"
	fi
}

src_prepare() {
	epatch ${PATCHES[@]}
}

src_configure() {
	econf \
		--with-systemdsystemunitdir=$(systemd_get_unitdir) \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable perl) \
		$(use python && echo "--enable-python=python3") \
		$(use_enable sasl cyrus) \
		$(use_enable ssl openssl) \
		$(use_enable tcl tcl) \
		$(use_with test gtest "${S}/test/gtest")
}

src_install() {
	emake install DESTDIR="${D%/}"
	dodoc NOTICE README.md
	if use daemon; then
		newinitd "${FILESDIR}"/znc.initd-r1 znc
		newconfd "${FILESDIR}"/znc.confd-r1 znc
	fi
}

pkg_postinst() {
	if use !daemon; then
		elog
		elog "Run 'znc --makeconf' as the user you want to run ZNC as"
		elog "to make a configuration file"
		elog
	else
		elog
		elog "An init-script was installed in /etc/init.d"
		elog "A config file was installed in /etc/conf.d"
		if [[ ! -d "${EROOT}${ZNC_DATADIR}" ]]; then
			elog
			elog "Run 'emerge --config znc' under portage"
			elog "or 'cave config znc' under paludis to configure ZNC"
			elog "as a system-wide daemon."
			elog
			elog "To generate a new SSL certificate, run:"
			elog "  znc --system-wide-config-as znc --makepem -d ${ZNC_DATADIR}"
			elog "as root"
			elog
			elog "If migrating from a user-based install"
			elog "you can use your existing config files:"
			elog "  mkdir ${ZNC_DATADIR}"
			elog "  mv /home/\$USER/.znc/* ${ZNC_DATADIR}"
			elog "  rm -rf /home/\$USER/.znc"
			elog "  chown -R znc:znc ${ZNC_DATADIR}"
			elog
			elog "If you already have znc set up and want take advantage of the"
			elog "init script but skip of all the above, you can also edit"
			elog "  /etc/conf.d/znc"
			elog "and adjust the variables to your current znc user and config"
			elog "location."
			elog
			elog "Please make sure that your existing configuration contains"
			elog "  PidFile = /run/znc/znc.pid"
			elog "or that PidFile value matches the one in /etc/conf.d/znc"
			if [[ -d "${EROOT}"/etc/znc ]]; then
				elog
				ewarn "/etc/znc exists on your system."
				ewarn "Due to the nature of the contents of that folder,"
				ewarn "we have changed the default configuration to use"
				ewarn "	${ZNC_DATADIR}"
				ewarn "please move /etc/znc to ${ZNC_DATADIR}"
				ewarn "or adjust /etc/conf.d/znc"
			fi
		else
			elog "Existing config detected in ${ZNC_DATADIR}"
			if ! systemd_is_booted; then
				elog
				elog "Please make sure that your existing configuration contains"
				elog "  PidFile = /run/znc/znc.pid"
				elog "or that PidFile value matches the one in /etc/conf.d/znc"
			else
				elog "You're good to go :)"
			fi
		fi
		elog
	fi
}

pkg_config() {
	if use daemon && ! [[ -d "${EROOT}${ZNC_DATADIR}" ]]; then
		einfo "Press ENTER to interactively create a new configuration file for znc."
		einfo "To abort, press Control-C"
		read
		mkdir -p "${EROOT}${ZNC_DATADIR}" || die
		chown -R ${PN}:${PN} "${EROOT}${ZNC_DATADIR}" ||
			die "Setting permissions failed"
		"${EROOT}"/usr/bin/znc --system-wide-config-as znc -c -r -d "${EROOT}${ZNC_DATADIR}" ||
			die "Config failed"
		echo
		einfo "To start znc, run '/etc/init.d/znc start'"
		einfo "or add znc to a runlevel:"
		einfo "  rc-update add znc default"
	else
		if use daemon; then
			ewarn "${ZNC_DATADIR} already exists, aborting to avoid damaging"
			ewarn "any existing configuration. If you are sure you want"
			ewarn "to generate a new configuration, remove the folder"
			ewarn "and try again."
		else
			ewarn "To configure znc as a system-wide daemon you have to"
			ewarn "enable the 'daemon' use flag."
		fi
	fi
}
