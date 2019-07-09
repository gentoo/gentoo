# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="File manipulation utility methods"
HOMEPAGE="https://github.com/piotrmurach/tty-file"
SRC_URI="https://github.com/piotrmurach/tty-file/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/diff-lcs-1.3:0
	=dev-ruby/pastel-0.7*
	>=dev-ruby/tty-prompt-0.18:0
"

ruby_add_bdepend "test? ( dev-ruby/webmock )"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
}

each_ruby_prepare() {
	mkdir tmp || die
}
