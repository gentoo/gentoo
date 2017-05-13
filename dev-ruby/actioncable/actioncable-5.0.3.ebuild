# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

# Tests require many new dependencies, skipping for now
RESTRICT="test"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	>=dev-ruby/nio4r-1.2:0
	>=dev-ruby/websocket-driver-0.6.1:0 =dev-ruby/websocket-driver-0.6*
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/railties-4.2.0
		dev-ruby/test-unit:2
		>=dev-ruby/mocha-0.14.0:0.14
	)"
