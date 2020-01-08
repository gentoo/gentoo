# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Terminal strings styling with intuitive and clean API"
HOMEPAGE="https://github.com/piotrmurach/pastel"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/equatable-0.6:0
	>=dev-ruby/tty-color-0.5:0
"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
}
