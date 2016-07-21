# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby poppler-glib bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" app-text/poppler[cairo]"
DEPEND+=" app-text/poppler[cairo]"

RUBY_PATCHES=( ${P}-type-orientation.patch )

ruby_add_rdepend "dev-ruby/ruby-gdkpixbuf2
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gtk2-${PV}"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/if have_make/,/^  end/ s:^:#:' test/run-test.rb || die

	# Avoid tests downloading a test PDF directly.
	rm -f test/test_{annotation,document,page}.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
