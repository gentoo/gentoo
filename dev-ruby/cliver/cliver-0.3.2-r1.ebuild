# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_GEMSPEC="cliver.gemspec"

inherit ruby-fakegem

COMMIT=3d72e99af19c273a3f88adcd4b96c4b65b1b6d4b

DESCRIPTION="An easy way to detect and use command-line dependencies"
HOMEPAGE="https://yaauie.github.io/cliver/"
SRC_URI="https://github.com/yaauie/cliver/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="cliver-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files/find */' ${RUBY_FAKEGEM_GEMSPEC} || die
}
