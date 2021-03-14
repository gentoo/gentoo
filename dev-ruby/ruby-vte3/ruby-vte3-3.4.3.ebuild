# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby VTE bindings for use with GTK3"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/vte:2.91[introspection]"
RDEPEND+=" x11-libs/vte:2.91[introspection]"

ruby_add_bdepend "~dev-ruby/ruby-glib2-${PV}"
ruby_add_rdepend "~dev-ruby/ruby-gtk3-${PV}"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Avoid tests that require a real pty.
	rm -f test/test-pty.rb || die
}
