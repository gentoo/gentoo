# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Perform multipart-post requests using Faraday"
HOMEPAGE="https://github.com/tisba/faraday-follow-redirects"
SRC_URI="https://github.com/tisba/faraday-follow-redirects/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="faraday-follow-redirects-${PV}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend "|| ( dev-ruby/faraday:2 dev-ruby/faraday:1 )"

ruby_add_bdepend "test? ( dev-ruby/webmock )"

all_ruby_prepare() {
	sed -i -e "s:_relative ':'./:" ${RUBY_FAKEGEM_GEMSPEC} || die
}
