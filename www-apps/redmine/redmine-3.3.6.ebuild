# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
# ruby24 don't have required deps
USE_RUBY="ruby22 ruby23"
inherit eutils depend.apache ruby-ng user

DESCRIPTION="Flexible project management web application using the Ruby on Rails framework"
HOMEPAGE="https://www.redmine.org/"
SRC_URI="https://www.redmine.org/releases/${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
SLOT="0"
# All db-related USEs are ineffective since we depend on rails
# which depends on activerecord which depends on all ruby's db bindings
#IUSE="ldap openid imagemagick postgres sqlite mysql fastcgi passenger"
IUSE="imagemagick fastcgi ldap markdown passenger"

ruby_add_rdepend "
	dev-ruby/actionpack-action_caching
	dev-ruby/actionpack-xml_parser:0
	>=dev-ruby/builder-3.2.2:3.2
	>=dev-ruby/coderay-1.1.0
	dev-ruby/i18n:0.7
	>=dev-ruby/jquery-rails-3.1.4:3
	dev-ruby/loofah
	dev-ruby/mime-types:*
	dev-ruby/mimemagic
	>=dev-ruby/nokogiri-1.6.8
	dev-ruby/protected_attributes
	>=dev-ruby/rack-openid-0.2.1
	>=dev-ruby/rails-4.2.5.2:4.2
	>=dev-ruby/rails-html-sanitizer-1.0.3
	dev-ruby/request_store:1.0.5
	>=dev-ruby/roadie-rails-1.1.0
	>=dev-ruby/rbpdf-1.19.2
	>=dev-ruby/ruby-openid-2.3.0
	dev-ruby/rubygems
	fastcgi? ( dev-ruby/fcgi )
	imagemagick? ( >=dev-ruby/rmagick-2.14.0 )
	ldap? ( >=dev-ruby/ruby-net-ldap-0.12.0 )
	markdown? ( >=dev-ruby/redcarpet-3.3.2 )
	passenger? ( www-apache/passenger )
	"
# TODO add USE doc and test
#ruby_add_bdepend ">=dev-ruby/rdoc-2.4.2
#	dev-ruby/yard
#	test? (
#		>=dev-ruby/shoulda-3.3.2
#		>=dev-ruby/mocha-0.13.3
#		>=dev-ruby/capybara-2.0.0
#	)"

REDMINE_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup redmine
	enewuser redmine -1 -1 "${REDMINE_DIR}" redmine
}

all_ruby_prepare() {
	rm -r log files/delete.me Gemfile || die

	# bug #406605
	rm .{git,hg}ignore || die

	cat > "${T}/50${PN}" <<-EOF || die
		CONFIG_PROTECT="${EROOT%/}${REDMINE_DIR}/config"
		CONFIG_PROTECT_MASK="${EROOT%/}${REDMINE_DIR}/config/locales ${EROOT%/}${REDMINE_DIR}/config/settings.yml"
	EOF

	# remove ldap staff module if disabled to avoid #413779
	use ldap || rm app/models/auth_source_ldap.rb || die

	eapply "${FILESDIR}/${PN}-3.4.3_requires.patch"
}

all_ruby_install() {
	dodoc doc/* README.rdoc
	rm -r doc appveyor.yml CONTRIBUTING.md README.rdoc || die

	keepdir /var/log/${PN}

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
		einfo "Clear the cache and the existing sessions."
		${RUBY} -S rake tmp:cache:clear || die
		${RUBY} -S rake tmp:sessions:clear || die
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
		chown redmine:redmine "${EROOT%/}var/log/redmine/*.log" || die
		einfo
		einfo "If you use sqlite3, please do not forget to change the ownership"
		einfo "of the sqlite files."
		einfo
		einfo "# cd \"${EROOT%/}${REDMINE_DIR}\""
		einfo "# chown redmine:redmine db/ db/*.sqlite3"
		einfo
	fi
}
