# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activejob/activejob-4.2.2.ebuild,v 1.1 2015/06/16 21:58:12 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

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
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.3.0
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/mocha-0.14.0:0.14
	)"

all_ruby_prepare() {
	# Set test environment to our hand.
	sed -i -e '/load_paths/d' test/helper.rb || die "Unable to remove load paths"

	# Remove all currently unpackaged queues.
	sed -i -e 's/delayed_job qu que queue_classic resque sidekiq sneakers sucker_punch backburner//' Rakefile || die
}
