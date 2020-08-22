# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27"

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
}
