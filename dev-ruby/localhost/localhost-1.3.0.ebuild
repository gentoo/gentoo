# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="readme.md"
RUBY_FAKEGEM_GEMSPEC="localhost.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="Manage a local CA for self-signed localhost development servers"
HOMEPAGE="https://github.com/socketry/localhost"
SRC_URI="https://github.com/socketry/localhost/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"

ruby_add_bdepend "
	test? (
		dev-ruby/async-io
		dev-ruby/async-process
		dev-ruby/sus-fixtures-async
	)
"

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/covered/Id' config/sus.rb || die
}

each_ruby_test() {
	# Tests fail in parallel as it tries to use the same port so
	# manually replicate ruby-ng_sus for now, as ruby-ng_sus runs sus-parallel.
	${RUBY} -S sus || die
}
