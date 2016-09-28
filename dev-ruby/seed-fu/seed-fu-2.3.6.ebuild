# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="Advanced seed data handling for Rails"
HOMEPAGE="https://github.com/mbleigh/seed-fu"
SRC_URI="https://github.com/mbleigh/${PN}/archive/v.${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RUBY_S="${PN}-v.${PV}"

ruby_add_rdepend "
	>=dev-ruby/activerecord-3.1:*
	>=dev-ruby/activesupport-3.1:*"
ruby_add_bdepend "test? ( dev-ruby/sqlite3 )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' spec/spec_helper.rb || die "sed failed"
}
