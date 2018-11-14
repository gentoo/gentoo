# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A Ruby implementation of JSON Web Token draft 06"
HOMEPAGE="https://github.com/jwt/ruby-jwt"
SRC_URI="https://github.com/jwt/ruby-jwt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="ruby-jwt-${PV}"

all_ruby_prepare() {
	sed -i -e "/simplecov/ s:^:#:" \
		-e '/^SimpleCov.configure/,/^end/ s:^:#:' \
		-e '/codeclimate/I s:^:#:' \
		spec/spec_helper.rb || die
}
