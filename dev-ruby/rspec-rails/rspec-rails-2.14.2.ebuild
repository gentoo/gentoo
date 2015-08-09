# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.md"

inherit ruby-fakegem versionator

DESCRIPTION="RSpec's official Ruby on Rails plugin"
HOMEPAGE="http://rspec.info/"
SRC_URI="https://github.com/rspec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

SUBVERSION="$(get_version_component_range 1-2)"

ruby_add_rdepend ">=dev-ruby/activesupport-3.0
	>=dev-ruby/activemodel-3.0
	>=dev-ruby/actionpack-3.0
	>=dev-ruby/railties-3.0
	=dev-ruby/rspec-${SUBVERSION}*"

# Depend on the package being already installed for tests, because
# requiring ammeter will load it, and we need a consistent set of rspec
# and rspec-rails for that to work.
ruby_add_bdepend "test? ( =dev-ruby/mocha-0.10* >=dev-ruby/capybara-2.0.0 >=dev-ruby/ammeter-0.2.5 ~dev-ruby/rspec-rails-${PV} )"

all_ruby_prepare() {
	# Remove .rspec options to avoid dependency on newer rspec when
	# bootstrapping.
	rm .rspec || die

	# Remove specs that no longer work with Rails 4.1 due to changed naming.
	rm spec/generators/rspec/install/install_generator_spec.rb || die
}
