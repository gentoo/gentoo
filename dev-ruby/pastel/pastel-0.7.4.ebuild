# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="pastel.gemspec"

inherit ruby-fakegem

DESCRIPTION="Terminal strings styling with intuitive and clean API"
HOMEPAGE="https://github.com/piotrmurach/pastel"
SRC_URI="https://github.com/piotrmurach/pastel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

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
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
