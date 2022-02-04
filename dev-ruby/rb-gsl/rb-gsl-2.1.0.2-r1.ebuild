# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_NAME="gsl"
inherit ruby-fakegem multilib

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/gsl_native/extconf.rb)

DESCRIPTION="Ruby interface to GNU Scientific Library"
HOMEPAGE="https://github.com/SciRuby/rb-gsl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="doc"

DEPEND+=" >=sci-libs/gsl-2.3[deprecated]"
RDEPEND+=" >=sci-libs/gsl-2.3[deprecated]"

RUBY_S="${PN}-${P}"

ruby_add_bdepend "dev-ruby/narray"
ruby_add_rdepend "dev-ruby/narray"

all_ruby_prepare() {
	sed -i -e '/LOCAL_LIBS/ s: -l: -L#{path.gsub("ext", "lib")} -l:' ext/gsl_native/extconf.rb || die
	# nmatrix only tests
	rm -r test/gsl/nmatrix_tests || die
}

each_ruby_configure() {
	NARRAY=1 each_fakegem_configure
}

each_ruby_compile() {
	NARRAY=1 each_fakegem_compile
}

each_ruby_test() {
	NARRAY=1 ${RUBY} -Ilib:test:. -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}
