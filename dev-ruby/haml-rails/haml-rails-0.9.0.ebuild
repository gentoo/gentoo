# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Provides Haml generators for Rails 4"
HOMEPAGE="https://github.com/indirect/haml-rails"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/actionpack-4.0.1
	>=dev-ruby/activesupport-4.0.1
	>=dev-ruby/railties-4.0.1
	>=dev-ruby/haml-4.0.6
	>=dev-ruby/html2haml-1.0.1"

ruby_add_bdepend "test? ( >=dev-ruby/rails-4.0.1 )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
}
