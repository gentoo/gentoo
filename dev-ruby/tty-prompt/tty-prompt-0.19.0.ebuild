# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A beautiful and powerful interactive command line prompt"
HOMEPAGE="https://github.com/piotrmurach/tty-prompt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	=dev-ruby/necromancer-0.5*
	=dev-ruby/pastel-0.7*
	=dev-ruby/tty-reader-0.6*
"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
}
