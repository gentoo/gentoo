# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_NAME="gdk_pixbuf2"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome-${PV}/gdk_pixbuf2

DESCRIPTION="Ruby GdkPixbuf2 bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" test? ( x11-libs/gdk-pixbuf[jpeg] )"
RDEPEND+=" x11-libs/gdk-pixbuf[introspection]"

ruby_add_rdepend "~dev-ruby/ruby-gio2-${PV}"
