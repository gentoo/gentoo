# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/flog/flog-4.3.2.ebuild,v 1.2 2015/03/20 14:04:27 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Flog reports the most tortured code in an easy to read pain report"
HOMEPAGE="http://ruby.sadi.st/"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

ruby_add_rdepend ">dev-ruby/ruby_parser-3.1.0:3
	>=dev-ruby/sexp_processor-4.4:4"

each_ruby_test() {
	${RUBY} -Ilib test/test_flog.rb || die
}
