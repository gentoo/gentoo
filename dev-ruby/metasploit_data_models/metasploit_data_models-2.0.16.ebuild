# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRAINSTALL="app config db script spec"
RUBY_FAKEGEM_GEMSPEC="${PN}".gemspec
DESCRIPTION="The database layer for Metasploit"
HOMEPAGE="https://github.com/rapid7/metasploit_data_models"
SRC_URI="https://rubygems.org/gems/${P}.gem"

LICENSE="BSD"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
RESTRICT=test
#IUSE="development test"
IUSE=""

RDEPEND="${RDEPEND} !dev-ruby/metasploit_data_models:0"

ruby_add_rdepend "
		>=dev-ruby/activerecord-4.2.6:4.2[postgres]
		>=dev-ruby/activesupport-4.2.6:4.2
		dev-ruby/pg:*
		dev-ruby/postgres_ext
		>=dev-ruby/railties-4.2.6:4.2
		>=dev-ruby/recog-2.0.0:*
		dev-ruby/arel-helpers
		>=dev-ruby/metasploit-concern-2.0.0
		>=dev-ruby/metasploit-model-2.0.0
		<dev-ruby/thor-2.0"

ruby_add_bdepend "dev-ruby/bundler"

all_ruby_prepare() {
	[ -f Gemfile.lock ] && rm Gemfile.lock
	#if ! use development; then
		sed -i -e "/^group :development do/,/^end$/d" Gemfile || die
		sed -i -e "/s.add_development_dependency/d" "${PN}".gemspec || die
	#fi
	#if ! use test; then
		sed -i -e "/^group :test do/,/^end$/d" Gemfile || die
	#fi
	#if ! use test && ! use development; then
		sed -i -e "/^group :development, :test do/,/^end$/d" Gemfile || die
	#fi
	#use the stable version of pg
	sed -i "s/'pg', \"0.20.0\"/'pg', '0.21.0'/" metasploit_data_models.gemspec || die
}

each_ruby_prepare() {
	if [ -f Gemfile ]
	then
		BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
		BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}

all_ruby_install() {
	ruby_fakegem_binwrapper mdm_console mdm_console-${SLOT}
}
