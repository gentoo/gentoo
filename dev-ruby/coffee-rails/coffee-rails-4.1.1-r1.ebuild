# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem versionator

DESCRIPTION="Coffee Script adapter for the Rails asset pipeline"
HOMEPAGE="https://github.com/rails/coffee-rails"
SRC_URI="https://github.com/rails/coffee-rails/archive/v${PV}.tar.gz -> ${PV}.tar.gz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""

ruby_add_rdepend ">=dev-ruby/coffee-script-2.2.0
	>dev-ruby/railties-4:* <dev-ruby/railties-5.1:*"

all_ruby_prepare() {
	# Avoid dependency on git and bundler.
	sed -i -e 's/git ls-files/echo/' \
		-e '/bundler/I s:^:#:' Rakefile || die

	# Make sure a consistent rails version is loaded.
	sed -i -e '4igem "rails"' -e '/bundler/ s:^:#:' test/test_helper.rb || die
}
