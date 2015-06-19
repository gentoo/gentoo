# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gobject-introspection/ruby-gobject-introspection-2.2.3.ebuild,v 1.2 2015/03/25 16:31:56 graaff Exp $

EAPI=4
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/gobject-introspection

DESCRIPTION="Ruby GObjectIntrosprction bindings"
KEYWORDS="~amd64 ~ppc"
IUSE=""

DEPEND="${DEPEND} dev-libs/gobject-introspection"
RDEPEND="${RDEPEND} dev-libs/gobject-introspection"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"
