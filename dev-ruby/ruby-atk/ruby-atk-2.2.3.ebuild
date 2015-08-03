# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-atk/ruby-atk-2.2.3.ebuild,v 1.6 2015/08/03 19:12:16 pacho Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Atk bindings"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND+=" dev-libs/atk"
RDEPEND=" dev-libs/atk"

ruby_add_rdepend ">=dev-ruby/ruby-glib2-${PV}"
