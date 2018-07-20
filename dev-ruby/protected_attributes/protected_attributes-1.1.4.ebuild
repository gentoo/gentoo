# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Protect attributes from mass-assignment in ActiveRecord models"
HOMEPAGE="https://github.com/rails/protected_attributes"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="1"

LICENSE="MIT"

KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	=dev-ruby/activemodel-4*:* >=dev-ruby/activemodel-4.0.1:*
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	=dev-ruby/actionpack-4*
	=dev-ruby/activerecord-4*
	=dev-ruby/rails-4*
	dev-ruby/mocha
	dev-ruby/sqlite3
)"

all_ruby_prepare() {
	sed -i -e '/github/ s:^:#:' Gemfile || die
}
