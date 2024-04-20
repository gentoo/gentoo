# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="Beautiful logging for Ruby"
HOMEPAGE="https://github.com/socketry/console"
SRC_URI="https://github.com/socketry/console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/fiber-annotation
	dev-ruby/fiber-local
	dev-ruby/json
"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid dependency on covered.
	rm -f config/sus.rb || die

	# Avoid sandbox violation during tests
	sed -i -e 's:/tmp/:'"${TMPDIR}"'/:' test/console/output.rb || die
}
