# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Faraday adapter for Net::HTTP"
HOMEPAGE="https://github.com/lostisland/faraday-net_http"
SRC_URI="https://github.com/lostisland/faraday-net_http/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/faraday-2.5 )"

all_ruby_prepare() {
	sed -i -e "s:_relative ':'./:" ${RUBY_FAKEGEM_GEMSPEC} || die
}
