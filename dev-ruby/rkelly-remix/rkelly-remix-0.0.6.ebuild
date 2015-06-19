# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rkelly-remix/rkelly-remix-0.0.6.ebuild,v 1.2 2014/12/17 07:08:47 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="RKelly Remix is a fork of the RKelly JavaScript parser"
HOMEPAGE="https://github.com/nene/rkelly-remix"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="doc"

ruby_add_bdepend "doc? ( dev-ruby/hoe dev-ruby/rdoc )"

each_ruby_test() {
	${RUBY} -S testrb -Ilib:. test/test_*.rb test/*/test_*.rb || die
}
