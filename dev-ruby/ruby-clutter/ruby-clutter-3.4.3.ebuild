# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" media-libs/clutter[introspection]"
RDEPEND+=" media-libs/clutter[introspection]"

ruby_add_bdepend "
	test? (
		~dev-ruby/ruby-cairo-gobject-${PV}
		~dev-ruby/ruby-gobject-introspection-${PV}
		~dev-ruby/ruby-glib2-${PV}
		~dev-ruby/ruby-pango-${PV}
	)"
ruby_add_rdepend "~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
	~dev-ruby/ruby-pango-${PV}"
