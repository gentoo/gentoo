# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/asciidoctor/asciidoctor-1.5.2.ebuild,v 1.3 2015/05/06 15:23:21 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test features"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc README.adoc"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Processor for converting AsciiDoc source files or strings into HTML 5, DocBook 4.5 and other formats"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? (
	dev-util/cucumber
	dev-ruby/rspec-expectations:*
	dev-ruby/coderay
	dev-ruby/erubis
	dev-ruby/haml
	dev-ruby/nokogiri
	dev-ruby/slim
	dev-ruby/tilt )"

all_ruby_prepare() {
	rm Gemfile || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/asciidoctor.1
}
