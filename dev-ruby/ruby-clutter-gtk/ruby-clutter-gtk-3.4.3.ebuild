# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Clutter-GTK bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" media-libs/clutter-gtk[gtk,introspection]"
RDEPEND+=" media-libs/clutter-gtk[gtk,introspection]"

ruby_add_bdepend "~dev-ruby/ruby-glib2-${PV}
	~dev-ruby/ruby-clutter-gdk-${PV}"
ruby_add_rdepend "~dev-ruby/ruby-clutter-${PV}
	~dev-ruby/ruby-gtk3-${PV}"
