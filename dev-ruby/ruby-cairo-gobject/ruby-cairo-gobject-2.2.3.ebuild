# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-cairo-gobject/ruby-cairo-gobject-2.2.3.ebuild,v 1.2 2015/03/25 16:26:49 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

RUBY_S="ruby-gnome2-all-${PV}/cairo-gobject"

DESCRIPTION="Ruby cairo-gobject bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="${DEPEND} x11-libs/cairo"
RDEPEND="${RDEPEND} x11-libs/cairo"

ruby_add_rdepend "dev-ruby/rcairo
	>=dev-ruby/ruby-glib2-${PV}"
