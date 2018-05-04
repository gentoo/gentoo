# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="activestorage.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Attach cloud and local files in Rails applications"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activerecord-${PV}:*
	>=dev-ruby/marcel-0.3.1 =dev-ruby/marcel-0.3*
"

ruby_add_bdepend "
	test? (
		~dev-ruby/railties-${PV}
		dev-ruby/test-unit:2
		dev-ruby/mocha
	)"

all_ruby_prepare() {
	   # Remove items from the common Gemfile that we don't need for this
		# test run. This also requires handling some gemspecs.
		sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|aws-sdk-s3\|google-cloud-storage\|azure-storage\|blade\|bootsnap\|hiredis\|qunit-selenium\|chromedriver-helper\|redis\|rb-inotify\|sprockets\|stackprof\|websocket-client-simple\|libxml-ruby\)/ s:^:#:" \
			-e '/:job/,/end/ s:^:#:' \
			-e '/:test/,/^end/ s:^:#:' \
			-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
		rm ../Gemfile.lock || die
}
