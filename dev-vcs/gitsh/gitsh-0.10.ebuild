# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit autotools ruby-fakegem

DESCRIPTION="An interactive shell for git"
HOMEPAGE="https://github.com/thoughtbot/gitsh"
SRC_URI="https://github.com/thoughtbot/gitsh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

ruby_add_rdepend "
	dev-ruby/bundler
	dev-ruby/blankslate:0
	dev-ruby/coderay
	dev-ruby/diff-lcs
	dev-ruby/method_source
	dev-ruby/parslet
	dev-ruby/pry
	dev-ruby/slop:3
	dev-ruby/rspec:3
	dev-ruby/rspec-core:3
	dev-ruby/rspec-expectations:3
	dev-ruby/rspec-mocks:3
	dev-ruby/rspec-support:3
	"

DOCS="README.md"

each_ruby_prepare() {
	rm Gemfile.lock || die
	eautoreconf
}

each_ruby_configure() {
	default
}

each_ruby_compile() {
	default
}

all_ruby_install() {
	all_fakegem_install
	doman "${S}"/man/man1/${PN}.1
}
