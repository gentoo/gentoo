# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_NAME="RedCloth"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_EXTRADOC="README.rdoc CHANGELOG"

RUBY_FAKEGEM_REQUIRE_PATHS="lib/case_sensitive_require"

RUBY_FAKEGEM_GEMSPEC=redcloth.gemspec

RUBY_FAKEGEM_EXTENSIONS=(ext/redcloth_scan/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A module for using Textile in Ruby"
HOMEPAGE="https://github.com/jgarber/redcloth"
SRC_URI="https://github.com/jgarber/redcloth/archive/v${PV}.tar.gz -> ${RUBY_FAKEGEM_NAME}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

DEPEND+=" =dev-util/ragel-6*"

PATCHES=(
	"${FILESDIR}/${P}-load-documents.patch"
	"${FILESDIR}/${P}-cve-2023-31606-1.patch"
	"${FILESDIR}/${P}-cve-2023-31606-2.patch"
)

ruby_add_bdepend "
	>=dev-ruby/rake-0.8.7
	>=dev-ruby/rake-compiler-0.7.1
	test? ( >=dev-ruby/diff-lcs-1.1.2 )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile ${PN}.gemspec || die
	rm -f tasks/{release,rspec,rvm}.rake || die

	# Fix version
	sed -i -e '/TINY/ s/1/2/' lib/redcloth/version.rb || die
}

each_ruby_prepare() {
	${RUBY} -S rake ext/redcloth_scan/extconf.rb || die
}
