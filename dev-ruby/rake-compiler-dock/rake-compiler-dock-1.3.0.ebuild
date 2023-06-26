# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Performant priority queue with support for changing priority for Ruby"
HOMEPAGE="https://github.com/rake-compiler/rake-compiler-dock"
SRC_URI="https://github.com/rake-compiler/rake-compiler-dock/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/bundler-1.7
		<dev-ruby/bundler-3.0
		>=dev-ruby/rake-12
		>=dev-ruby/test-unit-3.0
	)
"
