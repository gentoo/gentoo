# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/creole/creole-0.5.0.ebuild,v 1.2 2015/01/31 17:29:28 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.creole"

inherit ruby-fakegem

DESCRIPTION="Creole-to-HTML converter for Creole, the lightweight markup language"
HOMEPAGE="https://github.com/minad/creole"
SRC_URI="https://github.com/minad/creole/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bacon )"
