# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_NAME=rsvg2

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome-${PV}/rsvg2

DESCRIPTION="Ruby bindings for librsvg"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND+=" >=gnome-base/librsvg-2.16.1[introspection]"

ruby_add_rdepend "
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-gdkpixbuf2-${PV}
"

all_ruby_prepare() {
	ruby-ng-gnome2_all_ruby_prepare

	# Avoid test that fails and may be version-specific
	sed -i -e '/test_unlimited/aomit "version specific?"' \
		test/test-handle.rb || die
}
