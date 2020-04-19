# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26"
inherit depend.apache ruby-ng

DESCRIPTION="Flexible project management web application using the Ruby on Rails framework"
HOMEPAGE="https://www.redmine.org/"
SRC_URI="https://www.redmine.org/releases/${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
SLOT="0"
IUSE="imagemagick fastcgi ldap markdown mysql passenger postgres sqlite"

DEPS="
	fastcgi? ( dev-ruby/fcgi )
	imagemagick? ( dev-ruby/mini_magick )
	ldap? ( dev-ruby/ruby-net-ldap )
	markdown? ( >=dev-ruby/redcarpet-3.5.0 )
	mysql? ( >=dev-ruby/mysql2-0.5.0:0.5 )
	passenger? ( www-apache/passenger )
	postgres? ( >=dev-ruby/pg-1.1.4:1 )
	sqlite? ( >=dev-ruby/sqlite3-1.4.0 )
	dev-ruby/actionpack-xml_parser:2
	>=dev-ruby/i18n-1.6.0:1
	>=dev-ruby/mail-2.7.1
	dev-ruby/mimemagic
	>=dev-ruby/mini_mime-1.0.1
	>=dev-ruby/nokogiri-1.10.0
	dev-ruby/rails:5.2
	>=dev-ruby/rbpdf-1.20.0
	dev-ruby/request_store:0
	>=dev-ruby/roadie-rails-2.1.0
	>=dev-ruby/rouge-3.12.0
	>=dev-ruby/ruby-openid-2.9.2
	dev-ruby/rack-openid
"

ruby_add_bdepend "${DEPS}"

RDEPEND="
	acct-group/redmine
	acct-user/redmine
"

REDMINE_DIR="/var/lib/${PN}"

all_ruby_prepare() {
	rm -fr log files/delete.me .github || die

	# bug #406605
	rm .{git,hg}ignore || die

	# newenvd not working here
	cat > "${T}/50${PN}" <<-EOF || die
		CONFIG_PROTECT="${EROOT%/}${REDMINE_DIR}/config"
		CONFIG_PROTECT_MASK="${EROOT%/}${REDMINE_DIR}/config/locales ${EROOT%/}${REDMINE_DIR}/config/settings.yml"
	EOF

	# Fixing versions in Gemfile
	sed -i -e "s/~>/>=/g" Gemfile || die

	sed -i -e "/csv/d" Gemfile || die
	sed -i -e "/group :development do/,/end$/d" Gemfile || die
	sed -i -e "/group :test do/,/end$/d" Gemfile || die

	if ! use imagemagick ; then
		sed -i -e "/group :minimagick do/,/end$/d" Gemfile || die
	fi
	if ! use ldap ; then
		# remove ldap stuff module if disabled to avoid #413779
		use ldap || rm app/models/auth_source_ldap.rb || die
		sed -i -e "/group :ldap do/,/end$/d" Gemfile || die
	fi
	if ! use markdown ; then
		sed -i -e "/group :markdown do/,/end$/d" Gemfile || die
	fi
}

all_ruby_install() {
	dodoc doc/* README.rdoc
	rm -r doc appveyor.yml CONTRIBUTING.md README.rdoc || die

	keepdir /var/log/${PN}

	# Additional dependency for Gemfile (#657156)
	if use fastcgi; then
		echo "gem \"fcgi\"" > Gemfile.local
	fi

	insinto "${REDMINE_DIR}"
	doins -r .
	insinto "${REDMINE_DIR}/config"
	doins "${FILESDIR}/additional_environment.rb"
	keepdir "${REDMINE_DIR}/files"
	keepdir "${REDMINE_DIR}/public/plugin_assets"

	fowners -R redmine:redmine \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/public/plugin_assets" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN}

	fowners redmine:redmine "${REDMINE_DIR}"

	# protect sensitive data, see bug #406605
	fperms -R go-rwx \
		"${REDMINE_DIR}/config" \
		"${REDMINE_DIR}/files" \
		"${REDMINE_DIR}/tmp" \
		/var/log/${PN}

	if use passenger; then
		has_apache
		insinto "${APACHE_VHOSTS_CONFDIR}"
		doins "${FILESDIR}/10_redmine_vhost.conf"
	fi

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/redmine.logrotate redmine

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}-3.initd" ${PN}
	doenvd "${T}/50${PN}"
}

pkg_postinst() {
	if [[ -e "${EROOT%/}${REDMINE_DIR}/config/initializers/session_store.rb" \
	|| -e "${EROOT%/}${REDMINE_DIR}/config/initializers/secret_token.rb" ]]
	then
		elog "Execute the following command to upgrade environment:"
		elog
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "For upgrade instructions take a look at:"
		elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	else
		elog "Execute the following command to initialize environment:"
		elog
		elog "# cd ${EROOT%/}${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml"
		elog "# chown redmine:redmine config/database.yml"
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
}

pkg_config() {
	# Remove old lock file
	rm -f "${EROOT%/}${REDMINE_DIR}/Gemfile.lock"

	if [[ ! -e "${EROOT%/}${REDMINE_DIR}/config/database.yml" ]]; then
		eerror "Copy ${EROOT%/}${REDMINE_DIR}/config/database.yml.example to"
		eerror "${EROOT%/}${REDMINE_DIR}/config/database.yml then edit this"
		eerror "file in order to configure your database settings for"
		eerror "\"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}
	if [[ ! -L /usr/bin/ruby ]]; then
		eerror "/usr/bin/ruby is not a valid symlink to any ruby implementation."
		eerror "Please update it via `eselect ruby`"
		die
	fi
	if [[ $RUBY_TARGETS != *$( eselect ruby show | awk 'NR==2' | tr  -d ' '  )* ]]
	then
		eerror "/usr/bin/ruby is currently not included in redmine's ruby targets:"
		eerror "${RUBY_TARGETS}."
		eerror "Please update it via `eselect ruby`"
		die
	fi
	local RUBY=${RUBY:-ruby}

	cd "${EROOT%/}${REDMINE_DIR}" || die
	if [[ -e "${EROOT%/}${REDMINE_DIR}/config/initializers/session_store.rb" ]]
	then
		einfo
		einfo "Generating secret token."
		einfo
		rm config/initializers/session_store.rb || die
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake generate_secret_token || die
	fi
	if [[ -e "${EROOT%/}${REDMINE_DIR}/config/initializers/secret_token.rb" ]]
	then
		einfo
		einfo "Upgrading database."
		einfo

		einfo "Generating secret token."
		# Migration from Redmine 2.x
		rm config/initializers/secret_token.rb || die
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake generate_secret_token || die

		einfo "Migrating database."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake db:migrate || die
		einfo "Upgrading the plugin migrations."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake redmine:plugins:migrate || die
		einfo "Clear the cache."
		${RUBY} -S rake tmp:cache:clear || die
	else
		einfo
		einfo "Initializing database."
		einfo

		einfo "Generating a session store secret."
		${RUBY} -S rake generate_secret_token || die
		einfo "Creating the database structure."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake db:migrate || die
		einfo "Populating database with default configuration data."
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake redmine:load_default_data || die
		chown redmine:redmine -R "${EROOT%/}/var/log/redmine/" || die
		einfo
		einfo "If you use sqlite3, please do not forget to change the ownership"
		einfo "of the sqlite files."
		einfo
		einfo "# cd \"${EROOT%/}${REDMINE_DIR}\""
		einfo "# chown redmine:redmine db/ db/*.sqlite3"
		einfo
	fi
}
