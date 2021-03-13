# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A module that adds logging/trace functionality"
HOMEPAGE="https://github.com/jpace/logue"

SRC_URI="https://github.com/jpace/logue/archive/v${PV}.tar.gz -> ${PN}-git-${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~sparc ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/rainbow:3"

ruby_add_bdepend "test? ( dev-ruby/paramesan )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	# Fix path to match installed gem path
	sed -i -e 's:logue/lib/logue:/lib/logue:' lib/logue/stack.rb || die
}
