# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGES README.md"

inherit ruby-fakegem

DESCRIPTION="Builds manuals in HTML and Unix man page format from Markdown"
HOMEPAGE="https://github.com/apjanke/ronn-ng"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc"

IUSE=""

RDEPEND+="!app-text/ronn"

ruby_add_rdepend "
	>=dev-ruby/kramdown-2.1:2
	>=dev-ruby/mustache-0.7.0
	>=dev-ruby/nokogiri-1.9.0:0
"

each_ruby_prepare() {
	# Make sure that we always use the right interpreter during tests.
	sed -i -e "/output/ s:ronn:${RUBY} bin/ronn:" test/test_ronn.rb
}

all_ruby_compile() {
	PATH="${S}/bin:${PATH}" rake man || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/ronn.1 man/ronn-format.7
}
