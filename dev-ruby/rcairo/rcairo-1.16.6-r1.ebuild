# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_NAME="cairo"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="AUTHORS NEWS"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby bindings for cairo"
HOMEPAGE="https://cairographics.org/rcairo/"

IUSE=""

SLOT="0"
LICENSE="|| ( Ruby-BSD GPL-2 )"
KEYWORDS="amd64 ~ppc ~x86"

RDEPEND="${RDEPEND}
	>=x11-libs/cairo-1.2.0[svg(+)]"
DEPEND="${DEPEND}
	>=x11-libs/cairo-1.2.0[svg(+)]"

ruby_add_bdepend "
	>=dev-ruby/pkg-config-1.2.2
	dev-ruby/ruby-glib2
	test? ( >=dev-ruby/test-unit-2.1.0-r1:2 dev-ruby/ruby-poppler )"

all_ruby_prepare() {
	# Avoid unneeded dependency
	sed -e '/native-package-installer/ s:^:#:' \
		-e '/def required_pkg_config_package/areturn true' \
		-e '/checking_for/,/^end/ s:^:#:' \
		-i ext/cairo/extconf.rb || die
	sed -i -e '/native-package-installer/,/Gem::Dependency/ d' ../metadata || die

	# Avoid test that requires unpackaged fixture
	sed -i -e '/sub_test_case..FreeTypeFontFace/,/^  end/ s:^:#:' test/test_font_face.rb || die
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
	${RUBY} -Ilib -r ./test/helper \
		-e 'gem "test-unit"; require "test/unit"; Dir.glob("test/**/test_*.rb") {|f| load f}' || die "tests failed"
}

each_ruby_install() {
	each_fakegem_install

	insinto $(ruby_get_hdrdir)
	doins ext/cairo/rb_cairo.h
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}
