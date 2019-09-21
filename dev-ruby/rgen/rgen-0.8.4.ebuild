# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"
RUBY_FAKEGEM_GEMSPEC="rgen.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby Modelling and Generator Framework"
HOMEPAGE="https://github.com/mthiede/rgen"
SRC_URI="https://github.com/mthiede/rgen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_bdepend "
	test? ( >=dev-ruby/minitest-5.10:5 >=dev-ruby/nokogiri-1.6.8.1 )
"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e 's/Can not use a Fixnum/Can not use a Integer/' test/metamodel_builder_test.rb || die
}
