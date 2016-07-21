# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"
inherit eutils depend.apache ruby-ng user

DESCRIPTION="Flexible project management web application using the Ruby on Rails framework"
HOMEPAGE="http://www.redmine.org/"
SRC_URI="http://www.redmine.org/releases/${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="GPL-2"
SLOT="0"
# All db-related USEs are ineffective since we depend on rails
# which depends on activerecord which depends on all ruby's db bindings
#IUSE="ldap openid imagemagick postgres sqlite mysql fastcgi passenger"
IUSE="ldap fastcgi passenger imagemagick"

ruby_add_rdepend "
	dev-ruby/rubygems
	>=dev-ruby/rails-4.2.5.2:4.2
	>=dev-ruby/jquery-rails-3.1.4:3
	>=dev-ruby/coderay-1.1.0
	>=dev-ruby/builder-3.0.4:3
	>=dev-ruby/roadie-rails-1.1.0
	dev-ruby/mime-types:*
	=dev-ruby/request_store-1.0.5
	>=dev-ruby/rbpdf-1.19.0
	dev-ruby/actionpack-action_caching
	dev-ruby/actionpack-xml_parser
	dev-ruby/protected_attributes
	>=dev-ruby/redcarpet-3.3.2
	>=dev-ruby/nokogiri-1.6.7.2
	ldap? ( >=dev-ruby/ruby-net-ldap-0.12.0 )
	>=dev-ruby/ruby-openid-2.3.0
	>=dev-ruby/rack-openid-0.2.1
	fastcgi? ( dev-ruby/fcgi )
	passenger? ( www-apache/passenger )
	imagemagick? ( >=dev-ruby/rmagick-2.14.0 )"
	#	ruby_targets_ruby19? (
#		postgres? ( >=dev-ruby/pg-0.11 )
#		sqlite3? ( dev-ruby/sqlite3 )
#		mysql? ( dev-ruby/mysql2:0.3 )
#	)

#ruby_add_bdepend ">=dev-ruby/rdoc-2.4.2
#	dev-ruby/yard
#	test? (
#		>=dev-ruby/shoulda-3.3.2
#		>=dev-ruby/mocha-0.13.3
#		>=dev-ruby/capybara-2.0.0
#		<dev-ruby/nokogiri-1.6.0
#	)"

REDMINE_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup redmine
	enewuser redmine -1 -1 "${REDMINE_DIR}" redmine
}

all_ruby_prepare() {
	rm -r log files/delete.me || die

	# bug #406605
	rm .gitignore .hgignore || die

	rm Gemfile || die

	echo "CONFIG_PROTECT=\"${EPREFIX}${REDMINE_DIR}/config\"" > "${T}/50${PN}"
	echo "CONFIG_PROTECT_MASK=\"${EPREFIX}${REDMINE_DIR}/config/locales ${EPREFIX}${REDMINE_DIR}/config/settings.yml\"" >> "${T}/50${PN}"

	# remove ldap staff module if disabled to avoid #413779
	use ldap || rm app/models/auth_source_ldap.rb || die

	# Make it work
	sed -i -e "1irequire 'request_store'" app/controllers/application_controller.rb || die
	sed -i -e "18irequire 'action_controller'" -e "19irequire 'action_controller/action_caching'"\
		app/controllers/welcome_controller.rb || die
	sed -i -e "4irequire 'action_dispatch/xml_params_parser'" -e "/Bundler/d" config/application.rb || die
	sed -i -e "18irequire 'protected_attributes'" app/models/custom_field.rb || die
	sed -i -e "19irequire 'roadie-rails'" app/models/mailer.rb || die
}

all_ruby_install() {
	dodoc doc/{CHANGELOG,INSTALL,README_FOR_APP,RUNNING_TESTS,UPGRADING}
	rm -r doc || die
	dodoc README.rdoc
	rm README.rdoc || die

	keepdir /var/log/${PN}
	dosym /var/log/${PN}/ "${REDMINE_DIR}/log"

	insinto "${REDMINE_DIR}"
	doins -r .
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
	else
		newconfd "${FILESDIR}/${PN}.confd" ${PN}
		newinitd "${FILESDIR}/${PN}-2.initd" ${PN}
	fi
	doenvd "${T}/50${PN}"
}

pkg_postinst() {
	einfo
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/session_store.rb" -o -e "${EPREFIX}${REDMINE_DIR}/config/initializers/secret_token.rb" ]; then
		elog "Execute the following command to upgrade environment:"
		elog
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "For upgrade instructions take a look at:"
		elog "http://www.redmine.org/wiki/redmine/RedmineUpgrade"
	else
		elog "Execute the following command to initialize environment:"
		elog
		elog "# cd ${EPREFIX}${REDMINE_DIR}"
		elog "# cp config/database.yml.example config/database.yml"
		elog "# \${EDITOR} config/database.yml"
		elog "# chown redmine:redmine config/database.yml"
		elog "# emerge --config \"=${CATEGORY}/${PF}\""
		elog
		elog "Installation notes are at official site"
		elog "http://www.redmine.org/wiki/redmine/RedmineInstall"
	fi
	einfo
}

pkg_config() {
	if [ ! -e "${EPREFIX}${REDMINE_DIR}/config/database.yml" ]; then
		eerror "Copy ${EPREFIX}${REDMINE_DIR}/config/database.yml.example to ${EPREFIX}${REDMINE_DIR}/config/database.yml"
		eerror "then edit this file in order to configure your database settings for \"production\" environment."
		die
	fi

	local RAILS_ENV=${RAILS_ENV:-production}
	if [ ! -L /usr/bin/ruby ]; then
		eerror "/usr/bin/ruby is not a valid symlink to any ruby implementation."
		eerror "Please update it via `eselect ruby`"
		die
	fi
	if [[ $RUBY_TARGETS != *$( eselect ruby show | awk 'NR==2' | tr  -d ' '  )* ]]; then
		eerror "/usr/bin/ruby is currently not included in redmine's ruby targets: ${RUBY_TARGETS}."
		eerror "Please update it via `eselect ruby`"
		die
	fi
	local RUBY=${RUBY:-ruby}

	cd "${EPREFIX}${REDMINE_DIR}" || die
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/session_store.rb" ]; then
		einfo
		einfo "Generating secret token."
		einfo
		rm config/initializers/session_store.rb || die
		RAILS_ENV="${RAILS_ENV}" ${RUBY} -S rake generate_secret_token || die
	fi
	if [ -e "${EPREFIX}${REDMINE_DIR}/config/initializers/secret_token.rb" ]; then
		einfo
		einfo "Upgrading database."
		einfo

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
		chown redmine:redmine "${EPREFIX}${REDMINE_DIR}"/log/production.log
		einfo
		einfo "If you use sqlite3, please do not forget to change the ownership of the sqlite files."
		einfo
		einfo "# cd \"${EPREFIX}${REDMINE_DIR}\""
		einfo "# chown redmine:redmine db/ db/*.sqlite3"
		einfo
	fi
}
