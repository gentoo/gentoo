# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_GEMSPEC="rash.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rash alt version for Hashie's own Rash"
HOMEPAGE="https://github.com/shishi/rash_alt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/hashie-4.1:4"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	sed -i -e '/git ls-files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
