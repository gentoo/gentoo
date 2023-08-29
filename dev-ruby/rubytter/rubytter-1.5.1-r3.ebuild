# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc examples/*"

inherit ruby-fakegem

DESCRIPTION="Rubytter is a simple twitter library"
HOMEPAGE="https://github.com/jugyo/rubytter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/json-1.1.3:* >=dev-ruby/oauth-0.3.6"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e '/check_dependencies/ s:^:#:' Rakefile || die

	# Make specs work with rspec 3
	sed -i -e 's/stub!/stub/ ; 250 s/pending/skip/' spec/rubytter_spec.rb || die

	# Make specs work with ruby30
	sed -i -e '27i{' -e '30i}' spec/rubytter/oauth_spec.rb || die
}
