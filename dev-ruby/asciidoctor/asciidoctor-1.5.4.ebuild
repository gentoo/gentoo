# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test features"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc README.adoc"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Processor for converting AsciiDoc into HTML 5, DocBook 4.5 and other formats"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? (
	dev-util/cucumber
	dev-ruby/rspec-expectations:*
	dev-ruby/asciimath
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
