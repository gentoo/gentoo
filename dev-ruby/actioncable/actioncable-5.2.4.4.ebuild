# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem eapi7-ver

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

# Tests require many new dependencies, skipping for now
RESTRICT="test"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	dev-ruby/nio4r:2
	>=dev-ruby/websocket-driver-0.6.1:0
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/railties-4.2.0
		dev-ruby/test-unit:2
		>=dev-ruby/mocha-0.14.0:0.14
	)"
