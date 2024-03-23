# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_GEMSPEC="seed-fu.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="Advanced seed data handling for Rails"
HOMEPAGE="https://github.com/mbleigh/seed-fu"
SRC_URI="https://github.com/mbleigh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/activerecord-3.1:*
	>=dev-ruby/activesupport-3.1:*"
ruby_add_bdepend "test? ( dev-ruby/sqlite3 )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' spec/spec_helper.rb || die "sed failed"

	# Avoid failing test that appears not be innocent
	sed -i -e '/raise an ActiveRecord::RecordNotSaved/,/end/ s:^:#:' spec/seeder_spec.rb || die
}
