# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit virtualx ruby-ng-gnome2

DESCRIPTION="Ruby VTE bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/vte:2.91"
RDEPEND+=" x11-libs/vte:2.91"

ruby_add_bdepend ">=dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend ">=dev-ruby/ruby-gtk3-${PV}"

all_ruby_prepare() {
	sed -i -e '/system/,/^  end/ s:^:#:' test/run-test.rb || die

	# Avoid tests that require a real pty.
	rm -f test/test-pty.rb || die
}

each_ruby_configure() {
	:
}

each_ruby_compile() {
	:
}

each_ruby_test() {
	VIRTUALX_COMMAND="${RUBY} test/run-test.rb"
	 virtualmake || die
}

each_ruby_install() {
	each_fakegem_install
}
