# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit user systemd

DESCRIPTION="OTRS is an Open source Ticket Request System"
HOMEPAGE="https://www.otrs.com/"
SRC_URI="https://ftp.otrs.org/pub/${PN}/${P}.tar.bz2"

LICENSE="AGPL-3+"
KEYWORDS="~amd64 ~x86"
IUSE="apache2 fastcgi +gd ldap mod_perl +mysql pdf postgres soap"
SLOT="0"

REQUIRED_USE="|| ( mysql postgres )"

DEPEND="media-libs/libpng:0"

RDEPEND="dev-perl/Apache-Reload
	dev-perl/Archive-Zip
	dev-perl/DBI
	dev-perl/IO-Socket-SSL
	dev-perl/JSON-XS
	dev-perl/LWP-UserAgent-Determined
	dev-perl/Mail-POP3Client
	dev-perl/Mail-IMAPClient
	>dev-perl/Net-DNS-0.60
	dev-perl/Template-Toolkit
	dev-perl/Text-CSV_XS
	dev-perl/TimeDate
	dev-perl/DateTime
	dev-perl/XML-LibXML-Simple
	dev-perl/XML-Parser
	dev-perl/YAML-LibYAML
	apache2? (
		mod_perl? (
			www-servers/apache:2
			=www-apache/libapreq2-2* www-apache/mod_perl
		)
		!fastcgi? ( !mod_perl? ( www-servers/apache:2[suexec] ) )
	)
	fastcgi? (
		dev-perl/FCGI
		virtual/httpd-fastcgi
	)
	!fastcgi? ( !apache2? ( virtual/httpd-cgi ) )
	gd? (
		dev-perl/GD
		dev-perl/GDTextUtil
		dev-perl/GDGraph
	)
	ldap? ( dev-perl/perl-ldap )
	mysql? ( dev-perl/DBD-mysql )
	postgres? ( dev-perl/DBD-Pg )
	pdf? (
		>=dev-perl/PDF-API2-0.73
		virtual/perl-Compress-Raw-Zlib
	)
	soap? (
		dev-perl/SOAP-Lite
		!=dev-perl/SOAP-Lite-0.711
		!=dev-perl/SOAP-Lite-0.712
	)
	"

OTRS_HOME="/var/lib/otrs"

pkg_setup() {
	# The enewuser otrs will fail if apache isn't there, but it's an optional dep
	# so we create the apache user here just in case
	enewgroup apache 81
	enewuser apache 81 -1 /var/www apache
	enewuser otrs -1 -1 "${OTRS_HOME}" apache
}

src_prepare() {
	rm -r "${S}/scripts"/auto_* || die

	pushd Kernel >/dev/null || die
	local i
	for i in *.dist; do
		cp "${i}" $(basename "${i}" .dist) || die
	done
	popd >/dev/null || die

	# Fix broken png file (and see pngfix help for exit codes)
	pngfix -q --out=out.png "${S}/var/httpd/htdocs/skins/Agent/default/img/otrs-verify.png"
	if [[ $? -gt 15 ]]; then
		die "pngfix failed"
	fi
	mv -f out.png "${S}/var/httpd/htdocs/skins/Agent/default/img/otrs-verify.png" || die

	sed -i -e "s:/opt/otrs:${EPREFIX%/}${OTRS_HOME}:g" "${S}"/Kernel/Config.pm \
		|| die "sed failed"

	sed -i -e "s:/opt/otrs:${EPREFIX%/}${OTRS_HOME}:g" "${S}"/Kernel/Config/Defaults.pm \
		|| die "sed failed"

	grep -lR "/opt" "${S}"/scripts | \
		xargs sed -i -e "s:/opt/otrs:${EPREFIX%/}${OTRS_HOME}:g" \
		|| die "sed failed"

	echo "CONFIG_PROTECT=\"${EPREFIX%/}${OTRS_HOME}/Kernel/Config.pm \
		${EPREFIX%/}${OTRS_HOME}/Kernel/Config/GenericAgent.pm\"" > "${T}/50${PN}" || die

	eapply_user
}

# This is too automagic, either einfo telling user or installing to /etc/cron.d/ should be preferred
pkg_config() {
	einfo "Installing cronjobs"
	crontab -u otrs "${EROOT%/}"/usr/share/doc/${PF}/crontab || die
}

src_install() {
	dodoc CHANGES.md README*

	insinto "${OTRS_HOME}"
	doins -r .fetchmailrc.dist .mailfilter.dist .procmailrc.dist RELEASE \
		Custom Kernel bin scripts var

	cat "${S}"/var/cron/*.dist > "${T}"/crontab || die
	insinto /usr/share/doc/${PF}/
	doins "${T}"/crontab

	local a
	for a in article log pics/images pics/stats pics sessions spool tmp tmp/CacheFileStorable
	do
		keepdir "${OTRS_HOME}/var/${a}"
	done
	doenvd "${T}/50${PN}"

	systemd_dounit "${FILESDIR}/otrs.service"
}

pkg_postinst() {
	einfo "Setting correct permissions ..."
	/usr/bin/env perl "${EROOT%/}${OTRS_HOME}"/bin/otrs.SetPermissions.pl "${EROOT%/}${OTRS_HOME}" \
		--otrs-user=otrs \
		--web-group=apache \
		|| die "Could not set permissions"

	einfo "Installation done!"
	elog "1) Rebuild your config now by running the following commands:"
	elog "sudo -u otrs /usr/bin/env perl "${EROOT%/}${OTRS_HOME}"/bin/otrs.Console.pl Maint::Config::Rebuild"
	elog "sudo -u otrs /usr/bin/env perl "${EROOT%/}${OTRS_HOME}"/bin/otrs.Console.pl Maint::Cache::Delete"
	elog ""
	elog "2) Enable cronjobs with the following command:"
	elog "crontab -u otrs crontab"
	elog ""
	elog "3) systemd users: enable and start OTRS daemon:"
	elog "systemctl enable otrs"
	elog "systemctl start otrs"
}
