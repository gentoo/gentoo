# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A sane configuration format"
HOMEPAGE="https://github.com/jm/toml"
SRC_URI="https://github.com/jm/toml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="test"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_bdepend "test? ( dev-ruby/minitest
		dev-ruby/multi_json )"

ruby_add_rdepend "dev-ruby/parslet"

all_ruby_prepare() {
	sed -i -e "s/, \"~> 1.5.0\"//" ${PN}.gemspec || die
	sed -i -e "s/, '~> 1.7.8'//" Gemfile || die
	sed -i -e "/simplecov/d" -e "/[Bb]undle/d" Rakefile Gemfile || die
	sed -i -e "/bundler/d" -e "1igem 'minitest', '~>5'" -e "s/MiniTest/Minitest/" test/test_*.rb || die

	# Avoid dependency on git.
	sed -i -e '/files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -S testrb -Ilib:test test/test_*.rb || die
}
