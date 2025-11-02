# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="dry-struct.gemspec"

inherit ruby-fakegem

DESCRIPTION="Typed structs and value objects"

HOMEPAGE="https://dry-rb.org/gems/dry-struct/"
SRC_URI="https://github.com/dry-rb/dry-struct/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64 ~hppa ppc ppc64 ~sparc ~x86"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/dry-core-1.1:1
	>=dev-ruby/dry-types-1.8.2:1
	>=dev-ruby/ice_nine-0.11:0
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "test? (
	dev-ruby/dry-monads
	dev-ruby/dry-struct
	dev-ruby/warning
)"

all_ruby_prepare() {
	# Avoid broken spec, already fixed upstream.
	sed -e '/with Test::User/ s/context/xcontext/' \
		-e '/with Test::SuperUSer/ s/context/xcontext/' \
		-i spec/extensions/pretty_print_spec.rb || die

	# Avoid spec for unpackaged optional super_diff
	rm -f spec/extensions/super_diff_spec.rb || die

	# Require a consistent cgi.rb version (needed for ruby32)
	sed -e '/require.*dry-struct/arequire "cgi"' \
		-i spec/spec_helper.rb || die
}
