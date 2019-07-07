# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc LICENSE.txt README.adoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A set of Asciidoctor extensions that enable you to add diagrams"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-diagram"
SRC_URI="https://github.com/asciidoctor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/asciidoctor-1.5.0 <dev-ruby/asciidoctor-3"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/c.formatter/ s:^:#:' spec/test_helper.rb || die

	# Avoid specs for unpackaged tools
	rm -f spec/{a2s,blockdiag,erd,mermaid,msc,nomnoml,shaape,svgbob,syntrax,umlet,vega,wavedrom}_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install
}
