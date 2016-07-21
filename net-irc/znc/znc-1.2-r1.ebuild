# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_3 )
inherit base python-single-r1 user

MY_PV=${PV/_/-}
DESCRIPTION="An advanced IRC Bouncer"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI=${EGIT_REPO_URI:-"git://github.com/znc/znc.git"}
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://znc.in/releases/${PN}-${MY_PV}.tar.gz"
	KEYWORDS="amd64 ~arm x86"
fi

HOMEPAGE="http://znc.in"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="daemon debug ipv6 perl python ssl sasl tcl"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	perl? ( >=dev-lang/perl-5.10 )
	python? ( ${PYTHON_DEPS} )
	sasl? ( >=dev-libs/cyrus-sasl-2 )
	ssl? ( >=dev-libs/openssl-0.9.7d:0 )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="
	virtual/pkgconfig
	perl? ( dev-lang/swig )
	python? (
		>=dev-lang/swig-2.0.8
	)
	${RDEPEND}
"

S=${WORKDIR}/${PN}-${MY_PV}

PATCHES=(
	"${FILESDIR}/${PN}-1.0-systemwideconfig.patch"
	"${FILESDIR}/${P}-webadmin-correctly-handle-channel-names.patch"
)

CONFDIR="/var/lib/znc"

pkg_setup() {
	if use python; then
		python-single-r1_pkg_setup
	fi
	if use daemon; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /dev/null ${PN}
	fi
}

src_prepare() {
	if [[ ${PV} == *9999* ]]; then
		./autogen.sh
	fi

	base_src_prepare
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable perl) \
		$(use python && echo "--enable-python=python3") \
		$(use_enable sasl cyrus) \
		$(use_enable ssl openssl) \
		$(use_enable tcl tcl)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc NOTICE README.md
	if use daemon; then
		newinitd "${FILESDIR}"/znc.initd znc
		newconfd "${FILESDIR}"/znc.confd znc
	fi
}

pkg_postinst() {
	if use !daemon; then
		elog
		elog "Run 'znc --makeconf' as the user you want to run ZNC as"
		elog "to make a configuration file"
		elog "If you are using SSL you should also run 'znc --makepem'"
		elog
	else
		elog
		elog "An init-script was installed in /etc/init.d"
		elog "A config file was installed in /etc/conf.d"
		if [[ ! -d "${EROOT}${CONFDIR}" ]]; then
			elog
			elog "Run 'emerge --config znc' to configure ZNC"
			elog "as a system-wide daemon."
			elog
			elog "If you are using SSL you should also run:"
			elog "  znc --system-wide-config-as znc --makepem -d ${CONFDIR}"
			elog "as root"
			elog
			elog "If migrating from a user-based install"
			elog "you can use your existing config files:"
			elog "  mkdir ${CONFDIR}"
			elog "  mv /home/\$USER/.znc/* ${CONFDIR}"
			elog "  rm -rf /home/\$USER/.znc"
			elog "  chown -R znc:znc ${CONFDIR}"
			elog
			elog "If you already have znc set up and want take advantage of the"
			elog "init script but skip of all the above, you can also edit"
			elog "  /etc/conf.d/znc"
			elog "and adjust the variables to your current znc user and config"
			elog "location."
			if [[ -d "${EROOT}"/etc/znc ]]; then
				elog
				ewarn "/etc/znc exists on your system."
				ewarn "Due to the nature of the contents of that folder,"
				ewarn "we have changed the default configuration to use"
				ewarn "	/var/lib/znc"
				ewarn "please move /etc/znc to /var/lib/znc"
				ewarn "or adjust /etc/conf.d/znc"
			fi
		else
			elog "Existing config detected in ${CONFDIR}"
			elog "You're good to go :)"
		fi
		elog
	fi
}

pkg_config() {
	if use daemon && ! [[ -d "${EROOT}${CONFDIR}" ]]; then
		einfo "Press ENTER to interactively create a new configuration file for znc."
		einfo "To abort, press Control-C"
		read
		mkdir -p "${EROOT}${CONFDIR}" || die
		chown -R ${PN}:${PN} "${EROOT}${CONFDIR}" ||
			die "Setting permissions failed"
		"${EROOT}"/usr/bin/znc --system-wide-config-as znc -c -r -d "${EROOT}${CONFDIR}" ||
			die "Config failed"
		echo
		einfo "To start znc, run '/etc/init.d/znc start'"
		einfo "or add znc to a runlevel:"
		einfo "  rc-update add znc default"
	else
		if use daemon; then
			ewarn "${CONFDIR} already exists, aborting to avoid damaging"
			ewarn "any existing configuration. If you are sure you want"
			ewarn "to generate a new configuration, remove the folder"
			ewarn "and try again."
		else
			ewarn "To configure znc as a system-wide daemon you have to"
			ewarn "enable the 'daemon' use flag."
		fi
	fi
}
