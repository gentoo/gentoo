# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="README.rdoc CHANGES"
RUBY_FAKEGEM_DOCDIR="doc"

inherit multilib ruby-fakegem

DESCRIPTION="A module for profiling Ruby code"
HOMEPAGE="https://github.com/ruby-prof/ruby-prof"
SRC_URI="https://github.com/ruby-prof/${PN}/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 dev-ruby/minitest )"

all_ruby_prepare() {
	# Avoid bundler
	sed -i -e '/bundler/I s:^:#:' -e '/:build/ s:^:#:' Rakefile || die

	sed -i -e '2igem "test-unit"' test/test_helper.rb || die

	# Fix a timing-dependant spec since its thresholds for success are
	# too tight.
	sed -i -e '/test_class_methods/,/^  end/ s:^:#:' test/measure_cpu_time_test.rb || die

	# We install the shared object in lib, not ext.
	sed -i -e 's#../ext/ruby_prof#../lib/ruby_prof#' lib/ruby-prof.rb || die

	# Avoid unneeded dependency on rake-compiler
	sed -i -e '/extensiontask/ s:^:#:' \
		-e '/ExtensionTask/,/end/ s:^:#:' Rakefile || die

	# Create directory required for the test suite to pass
	mkdir tmp || die
}

each_ruby_configure() {
	${RUBY} -Cext/ruby_prof extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake V=1 -Cext/ruby_prof || die "build failed"

	cp ext/ruby_prof/*$(get_modname) lib/ || die "copy of extension failed"
}

all_ruby_install() {
	all_fakegem_install

	for dir in examples ; do
		docinto "$dir"
		dodoc -r "$dir"/*
	done
}
