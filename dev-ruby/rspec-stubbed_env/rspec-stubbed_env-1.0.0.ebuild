# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

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
KEYWORDS="~amd64"

ruby_add_rdepend ">=dev-ruby/rspec-3.0"
