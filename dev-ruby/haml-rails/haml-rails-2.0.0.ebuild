# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Provides Haml generators for Rails 4"
HOMEPAGE="https://github.com/indirect/haml-rails"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/actionpack-5.1:*
	>=dev-ruby/activesupport-5.1:*
	>=dev-ruby/railties-5.1:*
	>=dev-ruby/haml-4.0.6:* <dev-ruby/haml-6:*
	>=dev-ruby/html2haml-1.0.1"

ruby_add_bdepend "test? ( >=dev-ruby/rails-5.1 )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
}
