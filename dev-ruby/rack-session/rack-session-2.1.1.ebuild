# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="rack-session.gemspec"

inherit ruby-fakegem

DESCRIPTION="A session implementation for Rack"
HOMEPAGE="https://github.com/rack/rack-session"
SRC_URI="https://github.com/rack/rack-session/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/base64-0.1.0
	>=dev-ruby/rack-3.0.0
"

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/minitest-global_expectations
	dev-ruby/rack:3.1
)"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '2igem "rack", "~> 3.1.0"' \
		-e '2igem "minitest", "~> 5.0"' \
		-i test/helper.rb || die
}
