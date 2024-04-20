# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ensuring that the things you stub or mock actually exist"
HOMEPAGE="https://github.com/psyho/bogus"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/dependor-0.0.4"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' \
		-e '/SimpleCov/,/^end/ s:^:#:' spec/spec_helper.rb || die

	# Avoid dependency on unpackaged nulldb
	rm -f spec/bogus/fakes/fake_ar_attributes_spec.rb || die

	# Avoid keyword specs failing on ruby30
	rm -r spec/bogus/ruby_2* || die
}
