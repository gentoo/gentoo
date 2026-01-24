# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

# Latest releases have not been tagged upstream.
COMMIT=606fd91a80a36b3d9de50d864a3c926337b31c82

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_EXTRAINSTALL="tables"

RUBY_FAKEGEM_GEMSPEC="simpleidn.gemspec"

inherit ruby-fakegem

DESCRIPTION="Allows easy conversion from punycode ACE to unicode UTF-8 strings and vice-versa"
HOMEPAGE="https://github.com/mmriis/simpleidn"
SRC_URI="https://github.com/mmriis/simpleidn/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="simpleidn-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
