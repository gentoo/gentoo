# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Very lightweight libcurl wrapper"
HOMEPAGE="https://github.com/typhoeus/ethon"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" net-misc/curl"

ruby_add_rdepend ">=dev-ruby/ffi-1.3.0"

ruby_add_bdepend "test? ( dev-ruby/sinatra dev-ruby/mime-types )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/bundler/I s:^:#:' -i Rakefile spec/spec_helper.rb || die
}
