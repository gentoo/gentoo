# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby Modelling and Generator Framework"
HOMEPAGE="https://github.com/mthiede/rgen"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86"

ruby_add_rdepend "dev-ruby/nokogiri"

ruby_add_bdepend "doc? ( >=dev-ruby/rdoc-4.2.0 )"

each_ruby_test() {
	${RUBY} -Ilib -S testrb $(find test -type f -name '*_test.rb') || die
}
