# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22"

RUBY_FAKEGEM_NAME="cairo"

# Documentation depends on files that are not distributed.
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="AUTHORS NEWS"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby bindings for cairo"
HOMEPAGE="http://cairographics.org/rcairo/"

IUSE=""

SLOT="0"
LICENSE="|| ( Ruby GPL-2 )"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="${RDEPEND}
	>=x11-libs/cairo-1.2.0[svg]"
DEPEND="${DEPEND}
	>=x11-libs/cairo-1.2.0[svg]"

ruby_add_bdepend "
	dev-ruby/pkg-config
	dev-ruby/ruby-glib2
	test? ( >=dev-ruby/test-unit-2.1.0-r1:2 )"

all_ruby_prepare() {
	# Avoid development dependency.
	sed -i -e '/notify/ s:^:#:' test/cairo-test-utils.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/cairo extconf.rb || die "extconf failed"
}

each_ruby_compile() {
	emake V=1 -Cext/cairo

	# again, try to make it more standard, to install it more easily.
	cp ext/cairo/cairo$(get_modname) lib/ || die
}

each_ruby_test() {
	# don't rely on the Rakefile because it's a mess to load with
	# their hierarchy, do it manually.
	${RUBY} -Ilib -r ./test/cairo-test-utils.rb \
		-e 'gem "test-unit"; require "test/unit"; Dir.glob("test/**/test_*.rb") {|f| load f}' || die "tests failed"
}

each_ruby_install() {
	each_fakegem_install

	insinto $(ruby_get_hdrdir)
	doins ext/cairo/rb_cairo.h
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}/samples
	doins -r samples/*
}
