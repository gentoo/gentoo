# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby Modelling and Generator Framework"
HOMEPAGE="https://github.com/mthiede/rgen"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"

ruby_add_rdepend "dev-ruby/nokogiri"

all_ruby_prepare() {
	# Skip Bignum test since it fails on 64bit machines. Reported
	# upstream: https://github.com/mthiede/rgen/pull/18
	sed -e '273 s:^:#:' -i test/metamodel_builder_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb $(find test -type f -name '*_test.rb') || die
}
