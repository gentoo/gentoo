# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gobject-introspection/ruby-gobject-introspection-2.2.5.ebuild,v 1.2 2015/07/09 15:32:31 zlogene Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gobject-introspection

DESCRIPTION="Ruby GObjectIntrospection bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" dev-libs/gobject-introspection"
RDEPEND+=" dev-libs/gobject-introspection"

ruby_add_rdepend "~dev-ruby/ruby-glib2-${PV}"

all_ruby_prepare() {
	# Remove pregenerated Makefile since it will otherwise be shared by all targets.
	rm -f Makefile Makefile.lib ext/gobject-introspection/Makefile || die

	# Avoid unneeded dependency on test-unit-notify.
	sed -i -e '/notify/ s:^:#:' test/gobject-introspection-test-utils.rb || die

	# Avoid compilation of dependencies during test.
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}
