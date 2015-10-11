# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit ruby-ng

DESCRIPTION="Ruby Gnome2 bindings"
HOMEPAGE="http://ruby-gnome2.sourceforge.jp/"
SRC_URI=""

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/ruby-atk-${PV}
	>=dev-ruby/ruby-clutter-${PV}
	>=dev-ruby/ruby-clutter-gstreamer-${PV}
	>=dev-ruby/ruby-clutter-gtk-${PV}
	>=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-gdk3-${PV}
	>=dev-ruby/ruby-gio2-${PV}
	>=dev-ruby/ruby-gstreamer-${PV}
	>=dev-ruby/ruby-gtk2-${PV}
	>=dev-ruby/ruby-gtk3-${PV}
	>=dev-ruby/ruby-gtksourceview-${PV}
	>=dev-ruby/ruby-gtksourceview3-${PV}
	>=dev-ruby/ruby-pango-${PV}
	>=dev-ruby/ruby-poppler-${PV}
	>=dev-ruby/ruby-rsvg-${PV}
	>=dev-ruby/ruby-vte-${PV}
	>=dev-ruby/ruby-vte3-${PV}
	>=dev-ruby/ruby-webkit-gtk2-${PV}
	>=dev-ruby/ruby-webkit-gtk-${PV}"
