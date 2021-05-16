# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby binding of GDK specific API of Clutter"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" media-libs/clutter[gtk,introspection]"

ruby_add_rdepend "~dev-ruby/ruby-clutter-${PV}
	~dev-ruby/ruby-gdk3-${PV}"

# No test
unset -f each_ruby_test
