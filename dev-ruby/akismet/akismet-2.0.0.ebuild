# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/akismet/akismet-2.0.0.ebuild,v 1.1 2015/04/26 07:10:34 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A Ruby client for the Akismet API"
HOMEPAGE="https://github.com/jonahb/akismet"
SRC_URI="https://github.com/jonahb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="doc test"

# Tests now require an API key from akismet and a network connection.
RESTRICT="test"
