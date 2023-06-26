# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Defines an interface for external iterators for Ruby"
HOMEPAGE="https://github.com/monora/stream"
SRC_URI="https://github.com/monora/stream/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? (
		dev-ruby/rake
		dev-ruby/rdoc
		dev-ruby/test-unit
		dev-ruby/yard
	)
"
