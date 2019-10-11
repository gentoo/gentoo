# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc Manifest.txt README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="template"

inherit ruby-fakegem

DESCRIPTION="Hoe extends rake to provide full project automation"
HOMEPAGE="https://www.zenspider.com/projects/hoe.html"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.9:5 )"

ruby_add_rdepend ">=dev-ruby/rake-0.8.7 <dev-ruby/rake-13.0"

all_ruby_prepare() {
	# Skip isolation
	sed -i -e '/isolate/ s:^:#:' Rakefile || die

	# Skip test depending on specifics of gem command name
	sed -i -e '/test_nosudo/,/^  end/ s:^:#:' test/test_hoe.rb || die

	# Gem.bin_wrapper does not work as expected on Gentoo.
	sed -i -e 's/Gem.bin_wrapper//' lib/hoe/rcov.rb lib/hoe/publish.rb test/test_hoe_publish.rb || die

	# Fix broken test by including the right plugin first
	sed -i -e '/test_extensions/a Hoe.plugin :clean' test/test_hoe.rb || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc; then
		rdoc --title "seattlerb's hoe-3.5.1 Documentation" -o doc --main README.txt lib History.txt Manifest.txt README.txt || die
	fi
}
