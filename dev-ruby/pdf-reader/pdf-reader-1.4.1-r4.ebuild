# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GITHUB_USER=yob

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc TODO"

RUBY_FAKEGEM_GEMSPEC="pdf-reader.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="PDF parser conforming as much as possible to the PDF specification from Adobe"
HOMEPAGE="https://github.com/yob/pdf-reader/"

# We cannot use the gem distributions because they don't contain the
# tests' data, we have to rely on the git tags.
SRC_URI="https://github.com/${GITHUB_USER}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/afm-0.2.1
	=dev-ruby/ascii85-1*
	=dev-ruby/hashery-2*
	dev-ruby/ttfunk:*
	dev-ruby/ruby-rc4"

all_ruby_prepare() {
	# Remove bundler support
	sed -i -e '/[Bb]undler/d' spec/spec_helper.rb || die

	sed -i -e '/Ascii85/ s/1.0.0/1.0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
