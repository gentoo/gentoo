# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="globalid.gemspec"

inherit ruby-fakegem

DESCRIPTION="Reference models by URI"
HOMEPAGE="https://github.com/rails/globalid"
SRC_URI="https://github.com/rails/globalid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	<dev-ruby/activemodel-7.2
	<dev-ruby/railties-7.2
)"
ruby_add_rdepend ">=dev-ruby/activesupport-6.1:*"

all_ruby_prepare() {
	rm -f Gemfile.lock || die

	# Ensure a version of rails compatible with the tests.
	sed -e '/^gem / s/$/, "<7.2"/' \
		-i Gemfile || die
}
