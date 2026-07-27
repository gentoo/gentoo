# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="minitest-retry.gemspec"

RUBY_FAKEGEM_BINDIR="" # don't install upstreams helper scripts

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Re-run the test when the test fails"
HOMEPAGE="https://github.com/y-yagi/minitest-retry"
SRC_URI="https://github.com/y-yagi/minitest-retry/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	>=dev-ruby/minitest-5.0:*
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/debug
	)
"

all_ruby_prepare() {
	sed -e 's:git ls-files -z:find * -print0:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
