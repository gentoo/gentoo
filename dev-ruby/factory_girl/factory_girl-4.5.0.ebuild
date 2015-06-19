# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/factory_girl/factory_girl-4.5.0.ebuild,v 1.2 2015/03/24 20:10:21 maekke Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="yard"

# Tests depend on unpackaged appraisal, for now we just run the specs
# with the version of Rails that is installed.
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_EXTRADOC="GETTING_STARTED.md NEWS README.md"

RUBY_FAKEGEM_EXTRAINSTALL="features"

inherit ruby-fakegem

DESCRIPTION="factory_girl provides a framework and DSL for defining and using factories"
HOMEPAGE="https://github.com/thoughtbot/factory_girl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activesupport-3.0.0"

ruby_add_bdepend "
	test? (
		>=dev-ruby/activerecord-3.1
		dev-ruby/bourne
		>=dev-ruby/mocha-0.12.8
		dev-ruby/timecop
	)
"

all_ruby_prepare() {
	# Avoid unneeded test dependencies
	sed -i -e '/simplecov/ s:^:#:' spec/spec_helper.rb || die

	# Avoid specs that may fail due to more strict rspec 2.99
	# interpretation.
	sed -i -e '/callbacks using syntax methods without referencing FactoryGirl explicitly/,/^end/ s:^:#:' spec/acceptance/callbacks_spec.rb || die
}
