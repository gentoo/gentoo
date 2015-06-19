# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rgen/rgen-0.6.6-r2.ebuild,v 1.1 2015/04/16 17:58:13 mrueg Exp $

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

each_ruby_test() {
	${RUBY} -S testrb $(find test -type f -name '*_test.rb') || die
}
