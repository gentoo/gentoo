# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

COMMIT=7b8bdf7b33ab872bb4d1fb8eeecba5c5e1a4a421

RUBY_FAKEGEM_GEMSPEC="xml-simple.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/maik/xml-simple/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Easy API to maintain XML. A Ruby port of Grant McLean's Perl module XML::Simple"
HOMEPAGE="https://github.com/maik/xml-simple"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc x86"
IUSE=""

RUBY_S="${PN}-${COMMIT}"

ruby_add_rdepend "dev-ruby/rexml"

each_ruby_test() {
	cd test || die
	for i in *.rb; do
		${RUBY} -I../lib ${i} || die
	done
}
