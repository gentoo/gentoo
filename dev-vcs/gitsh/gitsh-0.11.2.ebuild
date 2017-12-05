# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit autotools ruby-fakegem

DESCRIPTION="An interactive shell for git"
HOMEPAGE="https://github.com/thoughtbot/gitsh"
SRC_URI="https://github.com/thoughtbot/gitsh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="test"

RDEPEND+=" sys-libs/readline "

DEPEND+=" test? ( dev-vcs/git ) "

ruby_add_rdepend "
	dev-ruby/bundler
	dev-ruby/parslet
	"

ruby_add_bdepend "test? ( dev-ruby/pry )"

DOCS="README.md"

all_ruby_prepare() {
	rm -f Gemfile.lock || die

	# Avoid integration tests that assume they can use /usr/bin/ruby
	rm -f spec/integration/running_scripts_spec.rb || die
	# or the TTY
	sed -i -e '/with valid arguments and no script file/,/^    end/ s:^:#:' spec/units/cli_spec.rb || die
}

each_ruby_prepare() {
	eautoreconf

	if use test; then
		git init . || die
	fi
}

each_ruby_configure() {
	RUBY=${RUBY} default
}

each_ruby_compile() {
	default
}

all_ruby_install() {
	all_fakegem_install
	doman "${S}"/man/man1/${PN}.1
}
