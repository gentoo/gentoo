# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-atk/ruby-atk-2.2.2.ebuild,v 1.1 2014/10/16 19:27:46 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND+=" dev-libs/atk"
RDEPEND+=" dev-libs/atk"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"

all_ruby_prepare() {
	sed -i -e "/notify/d" test/atk-test-utils.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
