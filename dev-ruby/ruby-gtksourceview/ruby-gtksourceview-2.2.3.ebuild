# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_NAME="gtksourceview2"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gtksourceview2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND+=" x11-libs/gtksourceview:2.0"
DEPEND+=" x11-libs/gtksourceview:2.0"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}"
