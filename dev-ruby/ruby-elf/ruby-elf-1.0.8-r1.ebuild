# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

GITHUB_URI="https://github.com/Flameeyes/${PN}"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

SRC_URI="${GITHUB_URI}/archive/${PV}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Ruby library to access ELF files information"
HOMEPAGE="https://www.flameeyes.eu/projects/ruby-elf"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"

ruby_add_bdepend "
	test? ( dev-ruby/test-unit:2 )
	dev-ruby/rake"

# for the man pages
DEPEND+="
	dev-libs/libxslt
	app-text/docbook-xsl-ns-stylesheets"

RDEPEND+="
	virtual/man"

all_ruby_compile() {
	# build the man pages
	rake manpages || die "rake manpages failed"
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}

all_ruby_install() {
	all_fakegem_install

	doman manpages/*.1
	dodoc DONATING README.md
}
