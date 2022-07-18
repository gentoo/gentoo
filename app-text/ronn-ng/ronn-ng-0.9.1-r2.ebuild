# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGES README.md"
RUBY_FAKEGEM_GEMSPEC="ronn-ng.gemspec"

inherit ruby-fakegem

DESCRIPTION="Builds manuals in HTML and Unix man page format from Markdown"
HOMEPAGE="https://github.com/apjanke/ronn-ng"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE=""

RDEPEND+="!app-text/ronn"

DEPS="
	>=dev-ruby/kramdown-2.1:2
	>=dev-ruby/nokogiri-1.9.0:0
"

ruby_add_rdepend "
	=dev-ruby/mustache-1*
	${DEPS}
"

ruby_add_bdepend "${DEPS}"

all_ruby_prepare() {
	sed -i -e '/mustache/ s/0.7/1.0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	# Make sure that we always use the right interpreter during tests.
	sed -i -e "/output/ s:ronn:${RUBY} bin/ronn:" test/test_ronn.rb || die
	sed -i -e "1igem 'psych', '~> 3.0'" Rakefile || die
}

all_ruby_compile() {
	PATH="${S}/bin:${PATH}" rake man || die
}

all_ruby_install() {
	all_fakegem_install

	doman man/ronn.1 man/ronn-format.7
}
