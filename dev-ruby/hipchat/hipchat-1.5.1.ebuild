# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="Ruby library to interact with HipChat"
HOMEPAGE="https://github.com/hipchat/hipchat-rb"
SRC_URI="https://github.com/hipchat/hipchat-rb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RUBY_S="hipchat-rb-${PV}"

ruby_add_rdepend "dev-ruby/httparty dev-ruby/mimemagic"
ruby_add_bdepend "test? (
		dev-ruby/rr
		dev-ruby/rake
		dev-ruby/webmock
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile ${PN}.gemspec || die "sed failed"
	sed -i -e '/git ls-files/d' ${PN}.gemspec || die "sed failed"

	sed -i -e '/coveralls/I s:^:#:' spec/spec_helper.rb || die
}
