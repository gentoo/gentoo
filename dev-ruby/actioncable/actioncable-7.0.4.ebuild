# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

# Tests require many new dependencies, skipping for now
RESTRICT="test"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	dev-ruby/nio4r:2
	>=dev-ruby/websocket-driver-0.6.1:*
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/railties-4.2.0
		dev-ruby/test-unit:2
		>=dev-ruby/mocha-0.14.0:0.14
	)"
