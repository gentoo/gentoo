# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/regexp_property_values/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR="lib/regexp_property_values"

inherit ruby-fakegem

DESCRIPTION="See which property values are supported by the regular expression engine"
HOMEPAGE="https://github.com/janosch-x/regexp_property_values"
SRC_URI="https://github.com/janosch-x/regexp_property_values/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die

	# Avoid dependency on character_set which would lead to circular
	# dependencies.
	sed -i -e '/returns a CharacterSet/askip "gentoo circular dependencies"' spec/regexp_property_values/value_spec.rb || die
}
