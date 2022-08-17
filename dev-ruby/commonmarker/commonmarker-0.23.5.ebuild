# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTENSIONS=(ext/commonmarker/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/commonmarker"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="commonmarker.gemspec"

inherit ruby-fakegem

DESCRIPTION="A fast, safe, extensible parser for CommonMark, wrapping the libcmark library"
HOMEPAGE="https://github.com/gjtorikian/commonmarker"
SRC_URI="https://github.com/gjtorikian/commonmarker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

# app-text/cmark is bundled in a modified way and integrated with the gem code

all_ruby_prepare() {
	sed -i -e '/focus/ s:^:#:' test/test_helper.rb || die

	# Avoid tests depending on unbundled cmark specification files
	rm -f test/test_{spec,smartpunct}.rb || die

}

each_ruby_prepare() {
	# Use current ruby version
	sed -i -e '/make_bin/,/end/ s:ruby:'${RUBY}':' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each {|f| require f}' || die
}
