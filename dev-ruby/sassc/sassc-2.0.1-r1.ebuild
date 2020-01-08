# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="sassc.gemspec"

inherit ruby-fakegem

DESCRIPTION="Use libsass with Ruby"
HOMEPAGE="https://github.com/sass/sassc-ruby"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="2"
IUSE=""

RDEPEND+=">=dev-libs/libsass-3.5.5"

ruby_add_rdepend "
	>=dev-ruby/ffi-1.9.6
	dev-ruby/rake
"

ruby_add_bdepend "test? (
	dev-ruby/test_construct
	dev-ruby/minitest-around
)"

all_ruby_prepare() {
	# Use unbundled libsass
	rm -rf ext || die

	sed -i -e '/spec =/,/ffi_lib/ s:^:#:' \
		-e '/ffi_lib/a    ffi_lib "/usr/lib64/libsass.so"' \
		lib/sassc/native.rb || die

	# Avoid version-specific test so newer libsass versions can be used.
	sed -i -e '/test_it_reports_the_libsass_version/,/end/ s:^:#:' test/native_test.rb || die

	sed -i -e '/pry/ s:^:#:' test/test_helper.rb || die

	sed -e 's/git ls-files -z/find . -print0/' \
		-e '/gem_dir/,/^  end/ s:^:#:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}
