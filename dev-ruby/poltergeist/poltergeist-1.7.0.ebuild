# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

# There are tests but they require several unpackaged dependencies.
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A PhantomJS driver for Capybara"
HOMEPAGE="https://github.com/jonleighton/poltergeist"
SRC_URI="https://github.com/jonleighton/poltergeist/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" www-client/phantomjs"

ruby_add_rdepend ">=dev-ruby/cliver-0.3.1
	dev-ruby/multi_json
	>=dev-ruby/capybara-2.1
	>=dev-ruby/websocket-driver-0.2.0"

all_ruby_prepare() {
	# Fix cliver versioning to accept all 0.x versions
	sed -i -e 's/0.3.1/0.3/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die

	# Remove integration tests for now since they require additional dependencies.
	rm -rf spec/integration
}
