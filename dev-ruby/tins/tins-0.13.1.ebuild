# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/tins/tins-0.13.1.ebuild,v 1.9 2014/10/30 13:58:53 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="All the stuff that isn't good enough for a real library"
HOMEPAGE="http://github.com/flori/tins"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 ) "

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib tests/*_test.rb
}
