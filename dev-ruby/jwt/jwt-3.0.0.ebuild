# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="ruby-jwt.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Ruby implementation of JSON Web Token draft 06"
HOMEPAGE="https://github.com/jwt/ruby-jwt"
SRC_URI="https://github.com/jwt/ruby-jwt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

RUBY_S="ruby-jwt-${PV}"

ruby_add_rdepend "dev-ruby/base64"

ruby_add_bdepend "test? ( dev-ruby/logger )"

all_ruby_prepare() {
	sed -i -e "/simplecov/ s:^:#:" \
		-e '/^SimpleCov.start/,/^end/ s:^:#:' \
		spec/spec_helper.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
