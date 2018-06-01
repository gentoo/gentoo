# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="cucumber"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="Date and time formatting for humans"
HOMEPAGE="https://github.com/jeremyw/stamp"
SRC_URI="https://github.com/jeremyw/stamp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=""
RDEPEND=""

ruby_add_bdepend "doc? ( dev-ruby/redcarpet )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile || die "sed failed"
	sed -i -e '/bundler/,+7d' features/support/env.rb || die "sed failed"
}
