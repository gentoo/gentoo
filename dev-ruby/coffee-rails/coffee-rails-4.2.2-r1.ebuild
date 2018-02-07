# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Coffee Script adapter for the Rails asset pipeline"
HOMEPAGE="https://github.com/rails/coffee-rails"
SRC_URI="https://github.com/rails/coffee-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux"

IUSE=""

ruby_add_rdepend ">=dev-ruby/coffee-script-2.2.0
	>dev-ruby/railties-4:*"

all_ruby_prepare() {
	# Avoid dependency on git and bundler.
	sed -i -e 's/git ls-files/echo/' \
		-e '/bundler/I s:^:#:' Rakefile || die

	# Make sure a consistent rails version is loaded.
	sed -i -e '4igem "railties"' -e '/bundler/ s:^:#:' test/test_helper.rb || die
}
