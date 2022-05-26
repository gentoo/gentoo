# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_GNOME2_NEED_VIRTX=yes

inherit ruby-ng-gnome2

DESCRIPTION="Ruby GtkSourceView4 bindings"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" x11-libs/gtksourceview:4[introspection]"
RDEPEND+=" x11-libs/gtksourceview:4[introspection]"

ruby_add_rdepend "~dev-ruby/ruby-gtk3-${PV}"
