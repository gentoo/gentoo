# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="yard"

# Tests depend on unpackaged appraisal, for now we just run the specs
# with the version of Rails that is installed.
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="GETTING_STARTED.md NEWS README.md"

RUBY_FAKEGEM_EXTRAINSTALL="features"

inherit ruby-fakegem

DESCRIPTION="factory_girl provides a framework and DSL for defining and using factories"
HOMEPAGE="https://github.com/thoughtbot/factory_girl"
SRC_URI="https://github.com/thoughtbot/factory_girl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.0.0:*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/activerecord-3.1[sqlite]
		dev-ruby/bourne
		>=dev-ruby/mocha-0.12.8
		dev-ruby/rspec-its
		dev-ruby/timecop
	)
"

all_ruby_prepare() {
	# Avoid unneeded test dependencies
	sed -i -e '/simplecov/ s:^:#:' \
		-e '1irequire "fileutils"' spec/spec_helper.rb || die

	# Avoid specs that may fail due to more strict rspec 2.99
	# interpretation.
	sed -i -e '/callbacks using syntax methods without referencing FactoryGirl explicitly/,/^end/ s:^:#:' spec/acceptance/callbacks_spec.rb || die
}
