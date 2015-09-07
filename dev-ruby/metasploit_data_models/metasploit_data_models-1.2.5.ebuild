# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/metasploit_data_models/metasploit_data_models-0.17.0.ebuild,v 1.3 2014/07/09 21:13:54 zerochaos Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem versionator

RUBY_FAKEGEM_EXTRAINSTALL="app config db script spec"

DESCRIPTION="The database layer for Metasploit"
HOMEPAGE="https://github.com/rapid7/metasploit_data_models"
SRC_URI="mirror://rubygems/${P}.gem"

LICENSE="BSD"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~x86"
RESTRICT=test
#IUSE="development test"
IUSE=""

RDEPEND="${RDEPEND} !dev-ruby/metasploit_data_models:0"

ruby_add_rdepend "
		>=dev-ruby/activerecord-4.0.9:4.0[postgres]
		>=dev-ruby/activesupport-4.0.9:4.0
		dev-ruby/pg
		dev-ruby/postgres_ext
		>=dev-ruby/railties-4.0.9:4.0
		dev-ruby/recog
		dev-ruby/arel-helpers
		>=dev-ruby/metasploit-concern-1.0.0:1.0
		>=dev-ruby/metasploit-model-1.0.0:1.0
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
