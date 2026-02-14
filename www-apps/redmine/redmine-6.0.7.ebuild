# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"
inherit depend.apache ruby-ng

DESCRIPTION="Flexible project management web application using the Ruby on Rails framework"
HOMEPAGE="https://www.redmine.org/"
SRC_URI="https://www.redmine.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fastcgi imagemagick ldap +minimagick mysql passenger pdf postgres +standalone sqlite"

ruby_add_bdepend "
	fastcgi? ( dev-ruby/fcgi )
	ldap? ( >=dev-ruby/ruby-net-ldap-0.17.0 )
	minimagick? ( >=dev-ruby/mini_magick-5.0.1 )
	mysql? (
		>=dev-ruby/mysql2-0.5.0:0.5
		dev-ruby/with_advisory_lock
	)
	passenger? ( www-apache/passenger )
	postgres? ( >=dev-ruby/pg-1.5.3:1 )
	sqlite? ( >=dev-ruby/sqlite3-1.7.0 )
	dev-ruby/actionpack-xml_parser:2
	dev-ruby/addressable
	>=dev-ruby/commonmarker-0.23.8
	>=dev-ruby/csv-3.2.8:3
	>=dev-ruby/deckar01-task_list-2.3.2
	>=dev-ruby/html-pipeline-2.13.2
	>=dev-ruby/i18n-1.14.1:1
	>=dev-ruby/mail-2.8.1
	dev-ruby/marcel
	>=dev-ruby/mini_mime-1.1.0
	>=dev-ruby/net-imap-0.5.7
	>=dev-ruby/net-pop-0.1.2
	>=dev-ruby/net-smtp-0.4.0
	>=dev-ruby/nokogiri-1.18.3
	>=dev-ruby/propshaft-1.1.0:1
	>=dev-ruby/rack-3.1.3:3.1
	>=dev-ruby/rails-7.2.2.2:7.2
	>=dev-ruby/rbpdf-1.21.4
	>=dev-ruby/redcarpet-3.6.0
	>=dev-ruby/request_store-1.5.0:0
	dev-ruby/rexml
	>=dev-ruby/roadie-rails-3.2.0:3
	>=dev-ruby/rotp-5.0.0
	>=dev-ruby/rouge-4.5.0
	dev-ruby/rqrcode
	>=dev-ruby/rubyzip-2.3.0:2
	>=dev-ruby/sanitize-6.0:6
"

RDEPEND="
	acct-group/redmine
	acct-user/redmine
	imagemagick? ( media-gfx/imagemagick )
	pdf? (
		app-text/ghostscript-gpl
		media-gfx/imagemagick
	)
	standalone? ( www-servers/puma )
"

REDMINE_DIR="/var/lib/${PN}"

all_ruby_prepare() {
	rm -fr log files/delete.me .github || die
	# remove empty unused directories
	rm -fr public/help || die

	# bug #406605
	rm .{git,hg}ignore || die

	# newenvd not working here
	cat > "${T}/50${PN}" <<-EOF || die
		CONFIG_PROTECT="${EROOT}/${REDMINE_DIR}/config"
		CONFIG_PROTECT_MASK="${EROOT}/${REDMINE_DIR}/config/locales ${EROOT}/${REDMINE_DIR}/config/settings.yml"
	EOF

	# Fixing versions in Gemfile
	sed -i -e "s/~>/>=/g" Gemfile || die

	# bug #724464
	sed -i -e "s/gem 'rails',.*/gem 'rails', '~>7.2.2'/" Gemfile || die

	sed -i -e "s/'deckar01-task_list',.*/'deckar01-task_list', '~>2.3.2'/" Gemfile || die

	sed -i -e "/group :development do/,/^end$/d" Gemfile || die
	sed -i -e "/group :test do/,/^end$/d" Gemfile || die

	if ! use imagemagick ; then
		sed -i -e "/group :minimagick do/,/^end$/d" Gemfile || die
	fi
	if ! use ldap ; then
		# remove ldap stuff module if disabled to avoid #413779
		use ldap || rm app/models/auth_source_ldap.rb || die
		sed -i -e "/group :ldap do/,/^end$/d" Gemfile || die
	fi
	# Additional dependency for Gemfile (#657156)
	if use fastcgi; then
		echo "gem 'fcgi'" >> Gemfile.local || die
	fi
	if use standalone; then
		echo "gem 'puma'" >> Gemfile.local || die
	fi
}

all_ruby_install() {
	dodoc doc/* README.rdoc
	rm -r doc test CONTRIBUTING.md README.rdoc || die

	keepdir /var/log/${PN}

	insinto "${REDMINE_DIR}"
	doins -r .
	insinto "${REDMINE_DIR}/config"
	doins "${FILESDIR}/additional_environment.rb"
	keepdir "${REDMINE_DIR}"/{app/views/previews,files,public/plugin_assets,vendor}
	keepdir "${REDMINE_DIR}"/tmp/{cache,imports,sessions,sockets}

	fowners -R redmine:redmine \
		"${REDMINE_DIR}/config.ru" \
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
		insinto "${APACHE_VHOSTS_CONFDIR}"
		doins "${FILESDIR}/10_redmine_vhost.conf"
	fi

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/redmine.logrotate redmine

	use standalone && newconfd "${FILESDIR}/${PN}.confd" ${PN}
	use standalone && newinitd "${FILESDIR}/${PN}-3.initd" ${PN}
	doenvd "${T}/50${PN}"
}

pkg_postinst() {
	if [[ -e "${EROOT}${REDMINE_DIR}/config/initializers/session_store.rb" \
	|| -e "${EROOT}${REDMINE_DIR}/config/initializers/secret_token.rb" ]]
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
		elog "# cd ${EROOT}${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml"
		elog "# chown redmine:redmine config/database.yml"
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
}

pkg_setup() {
	depend.apache_pkg_setup passenger
}

pkg_config() {
	# Remove old lock file
	rm -f "${EROOT}${REDMINE_DIR}/Gemfile.lock"

	if [[ ! -e "${EROOT}${REDMINE_DIR}/config/database.yml" ]]; then
		eerror "Copy ${EROOT}${REDMINE_DIR}/config/database.yml.example to"
		eerror "${EROOT}${REDMINE_DIR}/config/database.yml then edit this"
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

	cd "${EROOT}${REDMINE_DIR}" || die
	if [[ -e "${EROOT}${REDMINE_DIR}/config/initializers/session_store.rb" ]]
	then
		einfo
		einfo "Generating secret token."
		einfo
		rm config/initializers/session_store.rb || die
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake generate_secret_token || die
	fi
	if [[ -e "${EROOT}${REDMINE_DIR}/config/initializers/secret_token.rb" ]]
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
		chown redmine:redmine -R "${EROOT}/var/log/redmine/" || die
		einfo
		einfo "If you use sqlite3, please do not forget to change the ownership"
		einfo "of the sqlite files."
		einfo
		einfo "# cd \"${EROOT}${REDMINE_DIR}\""
		einfo "# chown redmine:redmine db/ db/*.sqlite3"
		einfo
	fi
}
