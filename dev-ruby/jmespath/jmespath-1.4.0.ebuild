# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Implements JMESPath for Ruby"
HOMEPAGE="https://github.com/jmespath/jmespath.rb"
SRC_URI="https://github.com/jmespath/jmespath.rb/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}.rb-${PV}"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~arm64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' \
		spec/{compliance_spec,compliance_without_errors_spec,spec_helper}.rb || die
	sed -i -e '/bundler/I s:^:#:' spec/spec_helper.rb || die
}
