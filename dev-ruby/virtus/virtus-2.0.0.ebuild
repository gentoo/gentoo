# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="Changelog.md CONTRIBUTING.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Attributes on Steroids for Plain Old Ruby Objects"
HOMEPAGE="https://github.com/solnic/virtus https://rubygems.org/gems/virtus"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/axiom-types-0.1
	<dev-ruby/axiom-types-1
	>=dev-ruby/coercible-1.0
	<dev-ruby/coercible-2
	>=dev-ruby/descendants_tracker-0.0.3
	<dev-ruby/descendants_tracker-1
"

ruby_add_bdepend "test? (
	dev-ruby/bogus
)"

all_ruby_prepare() {
	# Avoid specs that require unpackaged dry-inflector for now.
	rm -f spec/unit/virtus/class_methods/finalize_spec.rb || die

	# Fix specs for ruby 3.2
	sed -i -e 's/Fixnum/Integer/' spec/integration/inheritance_spec.rb || die

	# Avoid developer dependencies
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}
