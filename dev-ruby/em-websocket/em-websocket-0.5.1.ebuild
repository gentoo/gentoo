# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="EventMachine based WebSocket server"
HOMEPAGE="https://rubygems.org/gems/em-websocket"
SRC_URI="https://github.com/igrigorik/em-websocket/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/eventmachine-0.12.9
	=dev-ruby/http_parser_rb-0.6*
"

all_ruby_prepare() {
	# Avoid dependency on git
	sed -i -e '/ls-files/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Only run unit tests since we require unpackaged code for the
	# integration tests.
	sed -i -e "/^require 'em-\(spec\|http\|websocket-client\)/ s:^:#:" \
		-e "/^require 'integration/ s:^:#:" spec/helper.rb || die
	rm -fr spec/integration || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/
	doins -r examples
}
