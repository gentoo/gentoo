# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Rack::Test is a small, simple testing API for Rack apps"
HOMEPAGE="https://github.com/rack/rack-test"
SRC_URI="https://github.com/rack/rack-test/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/rack-1.3:*"
ruby_add_bdepend "
	test? ( dev-ruby/minitest:5 dev-ruby/minitest-global_expectations )"

all_ruby_prepare() {
	sed -e 's/git ls-files --/find/' \
		-e "s:_relative ': './:" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -w spec/all.rb || die
}
