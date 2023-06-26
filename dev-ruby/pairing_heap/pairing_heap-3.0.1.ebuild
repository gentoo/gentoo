# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Performant priority queue with support for changing priority for Ruby"
HOMEPAGE="https://github.com/mhib/pairing_heap"
SRC_URI="https://github.com/mhib/pairing_heap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest
		dev-ruby/rake
		dev-ruby/simplecov
		dev-ruby/standard
	)
"
