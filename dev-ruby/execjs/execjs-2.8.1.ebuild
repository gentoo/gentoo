# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
inherit ruby-fakegem

DESCRIPTION="ExecJS lets you run JavaScript code from Ruby"
HOMEPAGE="https://github.com/rails/execjs"
SRC_URI="https://github.com/rails/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86 ~amd64-linux ~x64-macos"

IUSE="test"

# execjs supports various javascript runtimes. They are listed in order
# as per the documentation. For now only include the ones already in the
# tree.

RDEPEND+=" || ( dev-ruby/duktape-rb net-libs/nodejs )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile || die
	# Avoid test requiring network connectivity. We could potentially
	# substitute dev-ruby/coffee-script-source for this.
	sed -i -e '/test_coffeescript/,/end/ s:^:#:' test/test_execjs.rb || die
}
