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

KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"

# Skip tests for now to avoid circular dependencies.
RESTRICT=test

ruby_add_rdepend "
	dev-ruby/concurrent-ruby:1
	>=dev-ruby/zeitwerk-2.6:2
"

#ruby_add_bdepend "test? (
#	dev-ruby/dry-types
#)"
