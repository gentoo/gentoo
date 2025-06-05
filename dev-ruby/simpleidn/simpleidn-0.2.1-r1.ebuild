# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_EXTRAINSTALL="tables"

RUBY_FAKEGEM_GEMSPEC="simpleidn.gemspec"

inherit ruby-fakegem

DESCRIPTION="Allows easy conversion from punycode ACE to unicode UTF-8 strings and vice-versa"
HOMEPAGE="https://github.com/mmriis/simpleidn"
SRC_URI="https://github.com/mmriis/simpleidn/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend ">=dev-ruby/unf-0.1.4 =dev-ruby/unf-0.1*"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
