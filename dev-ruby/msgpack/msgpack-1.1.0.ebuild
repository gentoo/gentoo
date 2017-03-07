# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Binary-based efficient data interchange format for ruby binding"
HOMEPAGE="https://msgpack.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86 ~x86-fbsd"
IUSE="doc"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die

	# Remove jruby-specific specs that are run also for other rubies.
	rm -rf spec/jruby || die

	sed -i -e '/git ls-files/d' msgpack.gemspec || die
}

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die "Configuration of extension failed."

	# rb_num2int is not inlined on 32 bit arches but also not explicitly
	# defined, bug 582968
	sed -i -e 's:-Wl,--no-undefined::' ext/${PN}/Makefile || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/msgpack$(get_modname) lib/${PN} || die "Unable to install msgpack library."
}
