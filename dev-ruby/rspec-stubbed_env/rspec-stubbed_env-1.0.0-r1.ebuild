# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

# Gem does not contain tests and upstream releases are not tagged
RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Stub environment variables in a scoped context for testing"
HOMEPAGE="https://github.com/pboling/rspec-stubbed_env"
IUSE=""
SLOT="1"

LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

ruby_add_rdepend ">=dev-ruby/rspec-3.0"
