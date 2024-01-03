# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Faraday adapter for Patron"
HOMEPAGE="https://github.com/lostisland/faraday-patron"
SRC_URI="https://github.com/lostisland/faraday-patron/archive/v1.0.tar.gz -> ${P}.tar.gz"
RUBY_S="faraday-patron-1.0"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/faraday:1 )"

all_ruby_prepare() {
	sed -i -e "s:_relative ':'./:" ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '2igem "faraday", "~> 1.0"' spec/spec_helper.rb || die

	# Avoid unpackaged, test-only, faraday-multipart for now.
#	sed -i -e '/multipart/ s:^:#:' spec/spec_helper.rb || die
#	sed -e '/should rewind files on retry/askip "faraday-multipart not packaged"' \
#		-i spec/faraday/retry/middleware_spec.rb || die
}
