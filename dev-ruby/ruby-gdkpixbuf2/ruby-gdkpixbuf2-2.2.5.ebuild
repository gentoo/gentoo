# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gdkpixbuf2/ruby-gdkpixbuf2-2.2.5.ebuild,v 1.1 2015/07/09 09:25:47 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_NAME="gdk_pixbuf2"

inherit ruby-ng-gnome2

RUBY_S=ruby-gnome2-all-${PV}/${RUBY_FAKEGEM_NAME}

DESCRIPTION="Ruby GdkPixbuf2 bindings"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND+=" x11-libs/gtk+:2"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"
