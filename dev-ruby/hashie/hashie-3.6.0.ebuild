# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Hashie is a small collection of tools that make hashes more powerful"
HOMEPAGE="https://www.mobomo.com/2009/11/hashie-the-hash-toolkit/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
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
