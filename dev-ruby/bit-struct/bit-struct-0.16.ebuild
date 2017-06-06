# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Library for packed binary data stored in ruby Strings"
HOMEPAGE="https://github.com/vjoel/bit-struct"

LICENSE="Ruby-BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
