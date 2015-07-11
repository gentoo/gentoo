# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtksourceview/ruby-gtksourceview-2.2.5.ebuild,v 1.1 2015/07/11 06:44:01 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_NAME="gtksourceview2"

inherit virtualx ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gtksourceview2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" x11-libs/gtksourceview:2.0"
DEPEND+=" x11-libs/gtksourceview:2.0"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"

all_ruby_prepare() {
	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	VIRTUALX_COMMAND="${RUBY} test/run-test.rb"
	 virtualmake || die
}
