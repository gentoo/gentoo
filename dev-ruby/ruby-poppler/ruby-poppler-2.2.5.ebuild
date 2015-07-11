# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-poppler/ruby-poppler-2.2.5.ebuild,v 1.1 2015/07/11 06:10:01 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby poppler-glib bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" app-text/poppler[cairo]"
DEPEND+=" app-text/poppler[cairo]"

ruby_add_rdepend "dev-ruby/ruby-gdkpixbuf2
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gtk2-${PV}"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/if have_make/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
