# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-ng

DESCRIPTION="Ruby Gnome2 bindings"
HOMEPAGE="http://ruby-gnome2.sourceforge.jp/"
SRC_URI=""

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

ruby_add_rdepend "
	~dev-ruby/ruby-atk-${PV}
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-clutter-${PV}
	~dev-ruby/ruby-clutter-gdk-${PV}
	~dev-ruby/ruby-clutter-gstreamer-${PV}
	~dev-ruby/ruby-clutter-gtk-${PV}
	~dev-ruby/ruby-gdkpixbuf2-${PV}
	~dev-ruby/ruby-gdk3-${PV}
	~dev-ruby/ruby-gegl-${PV}
	~dev-ruby/ruby-gio2-${PV}
	~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gnumeric-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
	~dev-ruby/ruby-goffice-${PV}
	~dev-ruby/ruby-gsf-${PV}
	~dev-ruby/ruby-gstreamer-${PV}
	~dev-ruby/ruby-gtk2-${PV}
	~dev-ruby/ruby-gtk3-${PV}
	~dev-ruby/ruby-gtksourceview-${PV}
	~dev-ruby/ruby-gtksourceview3-${PV}
	~dev-ruby/ruby-gtksourceview4-${PV}
	~dev-ruby/ruby-libsecret-${PV}
	~dev-ruby/ruby-pango-${PV}
	~dev-ruby/ruby-poppler-${PV}
	~dev-ruby/ruby-rsvg-${PV}
	~dev-ruby/ruby-vte-${PV}
	~dev-ruby/ruby-vte3-${PV}
	~dev-ruby/ruby-webkit2-gtk-${PV}
	~dev-ruby/ruby-wnck3-${PV}"
