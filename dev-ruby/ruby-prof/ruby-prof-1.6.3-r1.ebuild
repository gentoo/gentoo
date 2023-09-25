# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGES"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="ruby-prof.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/ruby_prof/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib"

inherit ruby-fakegem

DESCRIPTION="A module for profiling Ruby code"
HOMEPAGE="https://github.com/ruby-prof/ruby-prof"
SRC_URI="https://github.com/ruby-prof/${PN}/archive/${PV}.tar.gz -> ${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 dev-ruby/minitest )"

all_ruby_prepare() {
	# Avoid bundler
	sed -i -e '/bundler/I s:^:#:' -e '/:build/ s:^:#:' Rakefile || die

	sed -i -e '2igem "test-unit"' -e '/bundler/ s:^:#:' test/test_helper.rb || die

	# We install the shared object in lib, not ext.
	sed -i -e 's#../ext/ruby_prof#../lib/ruby_prof#' lib/ruby-prof.rb || die

	# Avoid unneeded dependency on rake-compiler
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/end/ s:^:#:' Rakefile || die

	# Don't strip library by default
	sed -i -e '/LDFLAGS/ s/-s//' ext/ruby_prof/extconf.rb || die
}
