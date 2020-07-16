# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[[ ${PV} == *9999 ]] && SCM="git-2"
inherit eutils perl-module user ${SCM}

DESCRIPTION="qpsmtpd is a flexible smtpd daemon written in Perl"
HOMEPAGE="https://smtpd.github.io/qpsmtpd/"
KEYWORDS=""
if [[ ${PV} != *9999 ]]; then
	SRC_URI="https://github.com/smtpd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	# This is a spotted development fork with many improvements
EGIT_REPO_URI="https://github.com/smtpd/${PN}.git"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="postfix ipv6 syslog"

RDEPEND=">=dev-lang/perl-5.8.0
	>=dev-perl/Net-DNS-0.690.0
	virtual/perl-MIME-Base64
	dev-perl/MailTools
	dev-perl/IPC-Shareable
	dev-perl/Socket6
	dev-perl/Danga-Socket
	dev-perl/ParaDNS
	dev-perl/UNIVERSAL-isa
	ipv6? ( dev-perl/IO-Socket-INET6 )
	syslog? ( virtual/perl-Sys-Syslog )
	virtual/inetd"

pkg_setup() {
	enewgroup smtpd
	local additional_groups
	if use postfix; then
		additional_groups="${additional_groups},postdrop"
	fi
	enewuser smtpd -1 -1 /var/spool/qpsmtpd smtpd${additional_groups}
}

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		unpack ${A}
		cd "${S}"
	else
		git-2_src_unpack
		cd "${S}"
	fi
}

src_install() {
	perl-module_src_install

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/qpsmtpd.xinetd qpsmtpd

	dodir /usr/share/qpsmtpd
	cp -Rf plugins "${D}"/usr/share/qpsmtpd/

	diropts -m 0755 -o smtpd -g smtpd
	dodir /var/spool/qpsmtpd
	keepdir /var/spool/qpsmtpd

	dodir /etc/qpsmtpd
	insinto /etc/qpsmtpd
	doins config.sample/*

	echo "/usr/share/qpsmtpd/plugins" > "${D}"/etc/qpsmtpd/plugin_dirs
	echo "/var/spool/qpsmtpd" > "${D}"/etc/qpsmtpd/spool_dir
	if use syslog; then
		echo "logging/syslog loglevel LOGINFO priority LOG_NOTICE" > "${D}"/etc/qpsmtpd/logging
	else
		diropts -m 0755 -o smtpd -g smtpd
		dodir /var/log/qpsmtpd
		keepdir /var/log/qpsmtpd
		echo "logging/file loglevel LOGINFO /var/log/qpsmtpd/%Y-%m-%d" > "${D}"/etc/qpsmtpd/logging
	fi

	newenvd "${FILESDIR}"/qpsmtpd.envd 99qpsmtpd

	newconfd "${FILESDIR}"/qpsmtpd.confd qpsmtpd
	newinitd "${FILESDIR}"/qpsmtpd.initd-r1 qpsmtpd

	dodoc CREDITS Changes README.md README.plugins.md STATUS UPGRADING.md
}
