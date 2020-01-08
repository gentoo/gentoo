# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils perl-module user

DESCRIPTION="qpsmtpd is a flexible smtpd daemon written in Perl"
HOMEPAGE="http://smtpd.develooper.com"
SRC_URI="http://smtpd.develooper.com/files/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="postfix ipv6 syslog"

RDEPEND=">=dev-lang/perl-5.8.0
	>=dev-perl/Net-DNS-0.690.0
	virtual/perl-MIME-Base64
	dev-perl/MailTools
	dev-perl/IPC-Shareable
	dev-perl/Socket6
	dev-perl/Danga-Socket
	dev-perl/ParaDNS
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

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.40-badrcptto_allowrelay.patch
	#epatch "${FILESDIR}"/${PN}-0.83-clamd_conf.patch
	epatch "${FILESDIR}"/${PN}-0.83-accept-empty-email.patch
	epatch "${FILESDIR}"/${PN}-0.84-Net-DNS-id.patch
}

src_install() {
	perl-module_src_install

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/qpsmtpd.xinetd qpsmtpd

	dodir /usr/share/qpsmtpd
	cp -Rf plugins "${D}"/usr/share/qpsmtpd/

	insinto /etc/qpsmtpd
	doins config.sample/*

	echo "/usr/share/qpsmtpd/plugins" > "${D}"/etc/qpsmtpd/plugin_dirs
	echo "/var/spool/qpsmtpd" > "${D}"/etc/qpsmtpd/spool_dir
	cat >"${D}"/etc/qpsmtpd/logging <<-EOF
		#logging/syslog loglevel LOGINFO priority LOG_NOTICE
		#logging/file loglevel LOGINFO /var/log/qpsmtpd/%Y-%m-%d
	EOF
	if use syslog; then
		sed -i -e '/^#logging\/syslog/s,^#,,g' "${D}"/etc/qpsmtpd/logging || die
	else
		sed -i -e '/^#logging\/file/s,^#,,g' "${D}"/etc/qpsmtpd/logging || die
	fi

	newenvd "${FILESDIR}"/qpsmtpd.envd 99qpsmtpd

	newconfd "${FILESDIR}"/qpsmtpd.confd qpsmtpd
	newinitd "${FILESDIR}"/qpsmtpd.initd-r1 qpsmtpd

	dodoc CREDITS Changes README README.plugins STATUS

	diropts -m 0755 -o smtpd -g smtpd
	dodir /var/spool/qpsmtpd /var/log/qpsmtpd
	keepdir /var/spool/qpsmtpd /var/log/qpsmtpd

}
