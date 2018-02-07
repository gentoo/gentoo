# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Job framework with pluggable queues"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.3.6
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/mocha-0.14.0:0.14
	)"

all_ruby_prepare() {
	# Set test environment to our hand.
	sed -i -e '1igem "activesupport", "~>5.0.0"' test/helper.rb || die

	# Remove all currently unpackaged queues.
	sed -i -e 's/delayed_job que queue_classic resque sidekiq sneakers sucker_punch backburner//' Rakefile || die
}
