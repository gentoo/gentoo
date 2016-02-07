# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Text handling for Twitter"
HOMEPAGE="https://github.com/twitter/twitter-text"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "=dev-ruby/unf-0.1*"

ruby_add_bdepend "test? ( >=dev-ruby/nokogiri-1.5.10 )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/end/ s:^:#:' spec/spec_helper.rb || die
}
