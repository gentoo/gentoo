# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Beautiful logging for Ruby"
HOMEPAGE="https://github.com/socketry/console"
SRC_URI="https://github.com/socketry/console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~sparc"
IUSE=""

ruby_add_rdepend "dev-ruby/fiber-local"

ruby_add_bdepend "test? ( dev-ruby/sus )"

all_ruby_prepare() {
	sed -i -E 's/require_relative "(.+)"/require File.expand_path("\1")/g' "${RUBY_FAKEGEM_GEMSPEC}" || die

	# Avoid dependency on covered.
	rm -f config/sus.rb || die

	# Avoid sandbox violation during tests
	sed -i -e 's:/tmp/:'"${TMPDIR}"'/:' test/console/output.rb || die
}

each_ruby_test() {
	${RUBY} -S sus-parallel || die
}
