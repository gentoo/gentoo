# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md docs/TEMPLATES.md"

RUBY_FAKEGEM_GEMSPEC="tilt.gemspec"

inherit ruby-fakegem

DESCRIPTION="Thin interface over template engines to make their usage as generic as possible"
HOMEPAGE="https://github.com/jeremyevans/tilt"
SRC_URI="https://github.com/jeremyevans/tilt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

# Block on some of the potential test dependencies. These dependencies
# are optional for the test suite, and we don't want to depend on all of
# them to facilitate keywording and stabling.
ruby_add_bdepend "test? (
	dev-ruby/erubi
	dev-ruby/nokogiri
)"

all_ruby_prepare() {
	sed -e '/bundler/I s:^:#:' -i Rakefile test/test_helper.rb || die
	sed -e '7irequire "uri"' -i test/test_helper.rb || die
}
