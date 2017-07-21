# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21"

inherit ruby-fakegem versionator

RUBY_FAKEGEM_EXTRAINSTALL="app config script spec"

DESCRIPTION="Common code, such as validators and mixins"
HOMEPAGE="https://github.com/rapid7/metasploit-model"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"
#IUSE="development test"
RESTRICT=test
IUSE=""

RDEPEND="${RDEPEND} !dev-ruby/metasploit-model:0"

ruby_add_rdepend ">=dev-ruby/railties-4.2.6:4.2
			>=dev-ruby/activesupport-4.2.6:4.2
			>=dev-ruby/activemodel-4.2.6:4.2"
#		development? (	dev-ruby/bundler
#			dev-ruby/rake
#			dev-ruby/i18n
#			dev-ruby/multi_json
#			dev-ruby/builder
#			dev-ruby/erubis
#			dev-ruby/journey
#			dev-ruby/rack
#			dev-ruby/rack-cache
#			dev-ruby/rack-test
#			dev-ruby/hike
#			dev-ruby/tilt
#			dev-ruby/sprockets:*
#			dev-ruby/actionpack:4.0
#			dev-ruby/json
#			dev-ruby/rack-ssl:*
#			dev-ruby/rdoc
#			dev-ruby/thor
#			dev-ruby/redcarpet
#			<dev-ruby/yard-0.8.7.4 )"

ruby_add_bdepend "dev-ruby/bundler"

all_ruby_prepare() {
	[ -f Gemfile.lock ] && rm Gemfile.lock
	#For now, we don't support development or testing at all
	#if ! use development; then
		sed -i -e "/^group :development do/,/^end$/d" Gemfile || die
		sed -i -e "/s.add_development_dependency/d" "${PN}".gemspec || die
		sed -i -e "/spec.add_development_dependency/d" "${PN}".gemspec || die
	#fi
	#if ! use test; then
		sed -i -e "/^group :test do/,/^end$/d" Gemfile || die
	#fi
	#if ! use test && ! use development; then
		sed -i -e "/^group :development, :test do/,/^end$/d" Gemfile || die
	#fi
}

each_ruby_prepare() {
	if [ -f Gemfile ]
	then
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
			BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}
