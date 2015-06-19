# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ejabberd/ejabberd-15.03-r1.ebuild,v 1.1 2015/04/14 03:39:56 radhermit Exp $

EAPI=5

inherit eutils multilib pam ssl-cert systemd

DESCRIPTION="The Erlang Jabber Daemon"
HOMEPAGE="http://www.ejabberd.im/ https://github.com/processone/ejabberd/"
SRC_URI="http://dev.gentoo.org/~radhermit/dist/${P}.tar.xz"
# upstream tarball missing bundled erlang libs that are fetched via git
#SRC_URI="https://www.process-one.net/downloads/downloads-action.php?file=/${PN}/${PV}/${P}.tgz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"
EJABBERD_MODULES="mod_bosh mod_irc mod_muc mod_proxy65 mod_pubsub"
IUSE="captcha debug elixir ldap mysql nls odbc pam postgres riak redis tools zlib ${EJABBERD_MODULES}"

DEPEND=">=net-im/jabber-base-0.01
	>=dev-libs/expat-1.95
	>=dev-libs/libyaml-0.1.4
	>=dev-lang/erlang-15.2[ssl]
	odbc? ( dev-db/unixODBC )
	ldap? ( =net-nds/openldap-2* )
	>=dev-libs/openssl-0.9.8e
	captcha? ( media-gfx/imagemagick[truetype,png] )
	zlib? ( >=sys-libs/zlib-1.2.3 )"
RDEPEND="${DEPEND}
	>=sys-apps/shadow-4.1.4.2-r3
	pam? ( virtual/pam )"

# paths in net-im/jabber-base
JABBER_ETC="${EPREFIX}/etc/jabber"
#JABBER_RUN="/var/run/jabber"
JABBER_SPOOL="${EPREFIX}/var/spool/jabber"
JABBER_LOG="${EPREFIX}/var/log/jabber"
JABBER_DOC="${EPREFIX}/usr/share/doc/${PF}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ejabberdctl.patch

	# don't install release notes (we'll do this manually)
	sed '/install .* [.][.]\/doc\/[*][.]txt $(DOCDIR)/d' -i Makefile.in || die
	# Set correct paths
	sed -e "/^EJABBERDDIR[[:space:]]*=/{s:ejabberd:${PF}:}" \
		-e "/^ETCDIR[[:space:]]*=/{s:@sysconfdir@/ejabberd:${JABBER_ETC}:}" \
		-e "/^LOGDIR[[:space:]]*=/{s:@localstatedir@/log/ejabberd:${JABBER_LOG}:}" \
		-e "/^SPOOLDIR[[:space:]]*=/{s:@localstatedir@/lib/ejabberd:${JABBER_SPOOL}:}" \
			-i Makefile.in || die
	sed -e "/EJABBERDDIR=/{s:ejabberd:${PF}:}" \
		-e "s|\(ETC_DIR=\){{sysconfdir}}.*|\1${JABBER_ETC}|" \
		-e "s|\(LOGS_DIR=\){{localstatedir}}.*|\1${JABBER_LOG}|" \
		-e "s|\(SPOOL_DIR=\){{localstatedir}}.*|\1${JABBER_SPOOL}|" \
			-i ejabberdctl.template || die

	# fix up the ssl cert paths in ejabberd.yml to use our cert and
	# also use the correct pam service name
	sed -e "s:/path/to/ssl.pem:/etc/ssl/ejabberd/server.pem:g" \
		-e "s:pamservicename:xmpp:" \
		-i ejabberd.yml.example || die

	# correct path to captcha script in default ejabberd.yml
	sed -e 's|\({captcha_cmd,[[:space:]]*"\).\+"}|\1/usr/'$(get_libdir)'/erlang/lib/'${P}'/priv/bin/captcha.sh"}|' \
		-i ejabberd.yml.example || die

	# disable mod_irc in ejabberd.yml
	if ! use mod_irc; then
		sed -e "s/{mod_irc,/%{mod_irc,/" \
			-i ejabberd.yml.example || die
	fi

	epatch_user
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--libdir="${EPREFIX}/usr/$(get_libdir)/erlang/lib/" \
		$(use_enable tools) \
		$(use_enable odbc) \
		$(use_enable mysql) \
		$(use_enable postgres pgsql) \
		$(use_enable pam) \
		$(use_enable zlib) \
		$(use_enable riak) \
		$(use_enable redis) \
		$(use_enable mod_bosh json) \
		$(use_enable nls iconv) \
		$(use_enable elixir) \
		$(use_enable debug) \
		--enable-lager \
		--enable-user=jabber

	# run configure scripts for all prefetched deps
	./rebar get-deps || die
}

src_compile() {
	emake $(use debug && echo debug=true ejabberd_debug=true)
}

src_install() {
	default

	# Pam helper module permissions
	# https://www.process-one.net/docs/ejabberd/guide_en.html#pam
	if use pam; then
		pamd_mimic_system xmpp auth account || die "Cannot create pam.d file"
		fowners root:jabber "/usr/$(get_libdir)/erlang/lib/${PF}/priv/bin/epam"
		fperms 4750 "/usr/$(get_libdir)/erlang/lib/${PF}/priv/bin/epam"
	fi

	newinitd "${FILESDIR}"/${PN}-3.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-3.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}.tmpfiles.conf

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "For configuration instructions, please see"
		elog "/usr/share/doc/${PF}/html/guide.html, or the online version at"
		elog "http://www.process-one.net/en/ejabberd/docs/guide_en/"
	else
		elog "Ejabberd now defaults to using a YAML format for its config file."
		elog "The old ejabberd.cfg file can be converted using the following instructions:"
		echo
		elog "1. Make sure all processes related to the previous version of ejabberd aren't running."
		elog "   Usually this just means the ejabberd daemon and possibly the pam-related processes"
		elog "   (epmd and epam) if pam support is enabled."
		elog "2. Run \`ejabberdctl start\` with sufficient permissions. Note that this can fail to"
		elog "   start ejabberd properly for various reasons. Check ejabberd's main log file"
		elog "   at /var/log/jabber/ejabberd.log to confirm it started successfully."
		elog "3. Run \`ejabberdctl convert_to_yaml /etc/jabber/ejabberd.cfg /etc/jabber/ejabberd.yml.new\`"
		elog "   with sufficient permissions, edit and rename /etc/jabber/ejabberd.yml.new to"
		elog "   /etc/jabber/ejabberd.yml, and finally restart ejabberd with the new config file."
		echo
	fi

	SSL_ORGANIZATION="${SSL_ORGANIZATION:-Ejabberd XMPP Server}"
	install_cert /etc/ssl/ejabberd/server
	# Fix ssl cert permissions bug #369809
	chown root:jabber "${EROOT}/etc/ssl/ejabberd/server.pem"
	chmod 0440 "${EROOT}/etc/ssl/ejabberd/server.pem"
}
