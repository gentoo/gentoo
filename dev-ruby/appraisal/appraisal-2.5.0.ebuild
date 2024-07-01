# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Ruby library for testing your library against different versions of dependencies"
HOMEPAGE="https://github.com/thoughtbot/appraisal"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/bundler
	dev-ruby/rake
	>=dev-ruby/thor-0.14.0
"

ruby_add_bdepend "test? (
	>=dev-ruby/activesupport-3.2.21
)"

all_ruby_prepare() {
	sed -i -e '/thor/ s:^:#:' Gemfile || die

	# Skip the acceptance tests since they expect to install gems from
	# the network and do not expect multiple ruby versions to be
	# present.
	rm -rf spec/acceptance || die
	sed -i -e '/built_in/ s:^:#:' spec/appraisal/appraisal_file_spec.rb || die
}
