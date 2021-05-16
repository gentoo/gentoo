# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem
DESCRIPTION="A Ruby library that lets you memoize methods"
HOMEPAGE="https://github.com/djberg96/memoize"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 ) "

all_ruby_prepare() {
	sed -i -e 's/Config/RbConfig/' Rakefile || die
}
