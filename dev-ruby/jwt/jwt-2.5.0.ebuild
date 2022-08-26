# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="ruby-jwt.gemspec"

inherit ruby-fakegem

DESCRIPTION="A Ruby implementation of JSON Web Token draft 06"
HOMEPAGE="https://github.com/jwt/ruby-jwt"
SRC_URI="https://github.com/jwt/ruby-jwt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="ruby-jwt-${PV}"

ruby_add_bdepend "test? ( dev-ruby/rbnacl )"

all_ruby_prepare() {
	sed -i -e "/simplecov/ s:^:#:" \
		-e '/^SimpleCov.start/,/^end/ s:^:#:' \
		spec/spec_helper.rb || die

	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
