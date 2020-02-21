# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="hashie.gemspec"

inherit ruby-fakegem

DESCRIPTION="Hashie is a small collection of tools that make hashes more powerful"
HOMEPAGE="https://www.mobomo.com/2009/11/hashie-the-hash-toolkit/"
SRC_URI="https://github.com/intridea/hashie/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/activesupport )"

all_ruby_prepare() {
	# Remove bundler and fix one spec that depends on its requires
	#rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -e '/pry/ s:^:#:' \
		-e '1irequire "pathname"; require "tempfile"' -i spec/spec_helper.rb || die

	# Avoid dependency on rspec-pending_for and its dependencies
	sed -i -e '/pending_for/ s:^:#:' \
		spec/spec_helper.rb \
		spec/hashie/mash_spec.rb \
		spec/hashie/extensions/strict_key_access_spec.rb || die

	# Avoid integration specs to avoid complicated dependencies
	rm spec/integration/{elasticsearch,omniauth*,rails}/integration_spec.rb || die
}
