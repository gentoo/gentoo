# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/gitsh/gitsh-0.8.ebuild,v 1.1 2014/11/05 11:44:28 jlec Exp $

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
	dev-ruby/blankslate:2
	dev-ruby/metaclass
	dev-ruby/bourne
	dev-ruby/coderay
	dev-ruby/diff-lcs
	dev-ruby/method_source
	dev-ruby/mocha:0.14
	dev-ruby/parslet
	dev-ruby/pry
	dev-ruby/slop:3
	dev-ruby/rspec:2
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
