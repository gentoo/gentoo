# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="dry-types.gemspec"

inherit ruby-fakegem

DESCRIPTION="Type system for Ruby supporting coercions, constraints and complex types."

HOMEPAGE="https://dry-rb.org/gems/dry-types/"
SRC_URI="https://github.com/dry-rb/dry-types/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="amd64 ~arm64 ~hppa ppc ppc64 sparc ~x86"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/bigdecimal:0
	dev-ruby/concurrent-ruby:1
	dev-ruby/dry-core:1
	dev-ruby/dry-inflector:1
	>=dev-ruby/dry-logic-1.4:1
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "test? (
	dev-ruby/dry-monads
	dev-ruby/dry-struct
	dev-ruby/warning
)"
