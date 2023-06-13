# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby31"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A Graph Library for Ruby"
HOMEPAGE="https://github.com/monora/rgl"
SRC_URI="https://github.com/monora/rgl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="${RDEPEND}"

ruby_add_rdepend "
	>=dev-ruby/rexml-3.2.4
"

ruby_add_bdepend "
	test? (
		dev-ruby/yard
		dev-ruby/rake
	)
"

