# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE=""

DEPEND+=" dev-libs/glib
	dev-libs/gobject-introspection
	x11-base/xorg-proto
	x11-libs/gtk+:3"
RDEPEND+=" dev-libs/glib
	dev-libs/gobject-introspection
	x11-libs/gtk+:3"

ruby_add_rdepend "
	~dev-ruby/ruby-atk-${PV}
	~dev-ruby/ruby-gdk3-${PV}"
ruby_add_bdepend "
	~dev-ruby/ruby-cairo-gobject-${PV}
	~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-gobject-introspection-${PV}
	~dev-ruby/ruby-pango-${PV}"

PATCHES=(
	"${FILESDIR}"/ruby-gtk3-4.1.2-c99.patch
)
