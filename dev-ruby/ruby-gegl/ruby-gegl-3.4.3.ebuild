# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby GEGL bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND+=" media-libs/gegl:0.4[introspection]"
RDEPEND+=" media-libs/gegl:0.4[introspection]"

ruby_add_rdepend "~dev-ruby/ruby-gio2-${PV}"
