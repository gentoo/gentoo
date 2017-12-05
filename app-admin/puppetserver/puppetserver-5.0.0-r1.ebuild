# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib systemd tmpfiles user

DESCRIPTION="Puppet Server is the next-generation application for managing Puppet agents."
HOMEPAGE="http://docs.puppetlabs.com/puppetserver/"
SRC_URI="https://downloads.puppetlabs.com/puppet/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="puppetdb"
# will need the same keywords as puppet
KEYWORDS="amd64 x86"

RDEPEND+="
		>=virtual/jdk-1.8.0
		app-admin/puppet-agent[puppetdb?]"
DEPEND+=""

pkg_setup() {
	enewgroup puppet
	enewuser puppet -1 -1 /opt/puppetlabs/server/data/puppetserver "puppet"
}

src_prepare() {
	sed -i 's/sysconfig\/puppetserver/systemd\/system\/puppetserver\.service\.d\/gentoo\.conf/g' ext/redhat/puppetserver.service || die
	sed -i 's/sysconfig\/puppetserver/systemd\/system\/puppetserver\.service\.d\/gentoo\.conf/g' ext/bin/puppetserver || die
	sed -i 's/sysconfig\/puppetserver/systemd\/system\/puppetserver\.service\.d\/gentoo\.conf/g' install.sh || die
	sed -i 's/var\/run/run/g' ext/config/conf.d/puppetserver.conf || die
	sed -i 's/var\/run/run/g' ext/redhat/puppetserver.service || die
	sed -i 's/var\/run/run/g' install.sh || die
	default
}

src_compile() {
		einfo "not compiling"
}

src_install() {
	insinto /opt/puppetlabs/server/apps/puppetserver
	insopts -m0774
	doins ext/ezbake-functions.sh
	insopts -m0644
	doins ext/ezbake.manifest
	doins puppet-server-release.jar
	doins jruby-9k.jar
	doins jruby-1_7.jar
	insinto /etc/puppetlabs/puppetserver
	doins ext/config/logback.xml
	doins ext/config/request-logging.xml
	insinto /etc/puppetlabs/puppetserver/services.d
	doins ext/system-config/services.d/bootstrap.cfg
	doins ext/config/services.d/ca.cfg
	insinto /etc/puppetlabs/puppetserver/conf.d
	doins ext/config/conf.d/puppetserver.conf
	doins ext/config/conf.d/auth.conf
	doins ext/config/conf.d/global.conf
	doins ext/config/conf.d/web-routes.conf
	doins ext/config/conf.d/metrics.conf
	doins ext/config/conf.d/webserver.conf
	insopts -m0755
	insinto /opt/puppetlabs/server/apps/puppetserver/scripts
	doins install.sh
	insinto /opt/puppetlabs/server/apps/puppetserver/cli/apps
	doins ext/cli/irb
	doins ext/cli/foreground
	doins ext/cli/gem
	doins ext/cli/ruby
	doins ext/cli/reload
	doins ext/cli/start
	doins ext/cli/stop
	insinto /opt/puppetlabs/server/apps/puppetserver/cli
	doins ext/cli_defaults/cli-defaults.sh
	insinto /opt/puppetlabs/server/apps/puppetserver/bin
	doins ext/bin/puppetserver
	insopts -m0644
	dodir /opt/puppetlabs/server/bin
	dosym ../apps/puppetserver/bin/puppetserver /opt/puppetlabs/server/bin/puppetserver
	dodir /opt/puppetlabs/bin
	dosym ../server/apps/puppetserver/bin/puppetserver /opt/puppetlabs/bin/puppetserver
	dosym ../../opt/puppetlabs/server/apps/puppetserver/bin/puppetserver /usr/bin/puppetserver
	dodir /opt/puppetlabs/server/apps/puppetserver/config/services.d
	# other sys stuff
	dodir /etc/puppetlabs/code
	# needed for systemd
	dodir /var/log/puppetlabs/puppetserver
	dodir /etc/puppetlabs/puppet/ssl
	fowners -R puppet:puppet /etc/puppetlabs/puppet/ssl
	fperms -R 771 /etc/puppetlabs/puppet/ssl
	# init type tasks
	newconfd ext/default puppetserver
	newinitd "${FILESDIR}/puppetserver.init" puppetserver
	# systemd type things
	insinto /etc/systemd/system/puppetserver.service.d/
	newins ext/default gentoo.conf
	systemd_dounit ext/redhat/puppetserver.service
	# misc
	insinto /etc/logrotate.d
	newins ext/puppetserver.logrotate.conf puppetserver
	# cleanup
	dodir /opt/puppetlabs/server/data/puppetserver/jruby-gems
	fowners -R puppet:puppet /opt/puppetlabs/server/data
	fperms -R 775 /opt/puppetlabs/server/data/puppetserver
	fperms -R 700 /var/log/puppetlabs/puppetserver
	insinto /opt/puppetlabs/server/data
	newins ext/build-scripts/gem-list.txt puppetserver-gem-list.txt
	newtmpfiles ext/puppetserver.tmpfiles.conf puppetserver.conf
}

pkg_postinst() {
	elog "to install you may want to run the following:"
	elog
	elog "puppet config set --section master vardir  /opt/puppetlabs/server/data/puppetserver"
	elog "puppet config set --section master logdir  /var/log/puppetlabs/puppetserver"
	elog "puppet config set --section master rundir  /run/puppetlabs/puppetserver"
	elog "puppet config set --section master pidfile /run/puppetlabs/puppetserver/puppetserver.pid"
	elog "puppet config set --section master codedir /etc/puppetlabs/code"
	elog
	elog "# install puppetserver gems"
	elog "cd /opt/puppetlabs/server/apps/puppetserver"
	elog "echo "jruby-puppet: { gem-home: ${DESTDIR}/opt/puppetlabs/server/data/puppetserver/vendored-jruby-gems }" > jruby.conf"
	elog "while read LINE"
	elog "do"
	elog "	java -cp puppet-server-release.jar:jruby-1_7.jar clojure.main -m puppetlabs.puppetserver.cli.gem --config jruby.conf -- install \$(echo \$LINE |awk '{print \$1}') --version \$(echo \$LINE |awk '{print \$2}')"
	elog "done < /opt/puppetlabs/server/data/puppetserver-gem-list.txt"
}
