# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"
RUBY_FAKEGEM_GEMSPEC=${PN}.gemspec

inherit ruby-fakegem

DESCRIPTION="Pry is a powerful alternative to the standard IRB shell for Ruby"
HOMEPAGE="https://github.com/pry/pry/wiki"
SRC_URI="https://github.com/pry/pry/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE=""
SLOT="ruby19"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

ruby_add_rdepend "
	>=dev-ruby/coderay-1.1:0
	=dev-ruby/method_source-1*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/open4-1.3
		>=dev-ruby/rake-0.9
		>=dev-ruby/mocha-1.0
	)"

all_ruby_prepare() {
	# Avoid unneeded dependency on git.
	# Loosen coderay dependency.
	sed -e '/git ls-files/d' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -e '/[Bb]undler/d' -i spec/spec_helper.rb || die

	# Skip integration tests because they depend to much on specifics of the environment.
	rm -f spec/integration/* || die
	sed -i -e '/loads files through repl and exits/askip "depends on parent directory"' spec/cli_spec.rb || die
}
