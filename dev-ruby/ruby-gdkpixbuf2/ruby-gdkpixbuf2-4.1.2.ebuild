# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_NAME="gdk_pixbuf2"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome-${PV}/gdk_pixbuf2

DESCRIPTION="Ruby GdkPixbuf2 bindings"
KEYWORDS="amd64 ~ppc ~riscv ~x86"
IUSE="test"

DEPEND+=" test? ( x11-libs/gdk-pixbuf[jpeg,gif(+)] )"
RDEPEND+=" x11-libs/gdk-pixbuf[introspection]"

ruby_add_rdepend "~dev-ruby/ruby-gio2-${PV}"
