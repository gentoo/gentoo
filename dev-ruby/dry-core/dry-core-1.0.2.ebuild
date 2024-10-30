# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="dry-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="A toolset of small support modules used throughout the dry-rb ecosystem"

HOMEPAGE="https://dry-rb.org/gems/dry-core/"
SRC_URI="https://github.com/dry-rb/dry-core/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_rdepend "
	dev-ruby/concurrent-ruby:1
	dev-ruby/logger
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "test? (
	dev-ruby/dry-inflector
	dev-ruby/dry-logic
	dev-ruby/dry-types
)"

all_ruby_prepare() {
	# Inflecto is not packaged
	sed -e '/with Inflecto/ s/context/xcontext/' \
		-i spec/dry/core/inflector_spec.rb || die
}
