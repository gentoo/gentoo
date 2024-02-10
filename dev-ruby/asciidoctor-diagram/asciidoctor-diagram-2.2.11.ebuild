# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.adoc LICENSE.txt README.adoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A set of Asciidoctor extensions that enable you to add diagrams"
HOMEPAGE="https://github.com/asciidoctor/asciidoctor-diagram"
SRC_URI="https://github.com/asciidoctor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND+=" virtual/jre"
DEPEND+=" test? (
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	media-gfx/imagemagick[png,postscript]
	media-gfx/graphviz
	media-sound/lilypond
	sci-visualization/gnuplot
)"
ruby_add_rdepend ">=dev-ruby/asciidoctor-1.5.7 <dev-ruby/asciidoctor-3"

all_ruby_prepare() {
	rm Gemfile || die
	sed -e '/c.formatter/ s:^:#:' \
		-e '/logger.*DEBUG/ s:^:#:' \
		-i spec/test_helper_methods.rb || die

	# Remove some diagram dependencies that contains vendored code and
	# are currently not packaged. Please file a bug if you have a need
	# for these diagram types.
	sed -i -e '/\(ditaamini\|plantuml\)/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid specs for unpackaged tools
	rm -f spec/{a2s,barcode,blockdiag,bpmn,bytefield,d2,dbml,diagrams,ditaa,dpic,erd,graphviz_py,mermaid,msc,nomnoml,pikchr,plantuml,shaape,smcat,structurizr,svgbob,symbolator,syntrax,umlet,vega,wavedrom}_spec.rb || die
}

all_ruby_install() {
	all_fakegem_install
}
