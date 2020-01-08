# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="See which property values are supported by the regular expression engine"
HOMEPAGE="https://github.com/janosch-x/regexp_property_values"
SRC_URI="https://github.com/janosch-x/regexp_property_values/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die

	# Avoid dependency on character_set which would lead to circular
	# dependencies.
	sed -i -e '/returns a CharacterSet/askip "gentoo circular dependencies"' spec/regexp_property_values/extension_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/regexp_property_values extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/regexp_property_values V=1
	cp ext/regexp_property_values/regexp_property_values.so lib/regexp_property_values/ || die
}
