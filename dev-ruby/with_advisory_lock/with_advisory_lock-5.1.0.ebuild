# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Advisory locking for ActiveRecord"
HOMEPAGE="https://github.com/ClosureTree/with_advisory_lock"
SRC_URI="https://github.com/ClosureTree/with_advisory_lock/archive/refs/tags/${PN}/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	>=dev-ruby/activerecord-6.1:*
	>=dev-ruby/zeitwerk-2.6
"
ruby_add_bdepend "test? (
	>=dev-ruby/activerecord-6.1:*[sqlite]
	dev-ruby/maxitest
	dev-ruby/mocha
)
"

all_ruby_unpack() {
	default
	mv "${WORKDIR}/all/${PN}-${PN}-v${PV}" "${WORKDIR}/all/${P}" || die
}

all_ruby_prepare() {
	sed -i -e "s:require_relative 'lib:require './lib:" ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e "/git ls-files/d" with_advisory_lock.gemspec || die
}
