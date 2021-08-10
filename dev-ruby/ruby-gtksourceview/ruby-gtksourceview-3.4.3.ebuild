# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_NAME="gtksourceview2"
RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome-${PV}/gtksourceview2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" dev-libs/glib
	x11-libs/gdk-pixbuf
	x11-libs/gtksourceview:2.0
	x11-libs/gtk+:2"
RDEPEND+=" dev-libs/glib
	x11-libs/gdk-pixbuf
	x11-libs/gtksourceview:2.0
	x11-libs/gtk+:2"

ruby_add_rdepend "~dev-ruby/ruby-gtk2-${PV}"
