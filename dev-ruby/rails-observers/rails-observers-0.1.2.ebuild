# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test:regular"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem versionator

DESCRIPTION="Rails Observers"
HOMEPAGE="https://github.com/rails/rails-observers"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64"
IUSE=""

RUBY_PATCHES=( "${P}-fix-tests.patch" )

ruby_add_rdepend "=dev-ruby/activemodel-4*"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		>=dev-ruby/minitest-3
		=dev-ruby/railties-4*
		=dev-ruby/activerecord-4*
		=dev-ruby/actionmailer-4*
		=dev-ruby/actionpack-4*
		>=dev-ruby/sqlite3-1.3
	)"

all_ruby_prepare() {
	# Avoid rake test since it will run with the wrong ruby interpreter.
	rm test/rake_test.rb || die
}
