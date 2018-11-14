# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24"

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
