# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"
RUBY_FAKEGEM_GEMSPEC="rgen.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby Modelling and Generator Framework"
HOMEPAGE="https://github.com/mthiede/rgen"
SRC_URI="https://github.com/mthiede/rgen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc x86"

ruby_add_bdepend "doc? ( >=dev-ruby/rdoc-4.2.0 )
	test? ( >=dev-ruby/minitest-5.10:5 >=dev-ruby/nokogiri-1.6.8.1 )
"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby24|*ruby25)
			sed -i -e 's/Can not use a Fixnum/Can not use a Integer/' test/metamodel_builder_test.rb || die
			;;
	esac
}
