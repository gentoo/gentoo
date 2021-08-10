# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Making tests easy on the fingers and eyes"
HOMEPAGE="http://thoughtbot.com/projects/shoulda"
SRC_URI="https://github.com/thoughtbot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

# This now more or less a meta-gem and it only contains features for
# integration tests using Appraisals, which we don't currently package.
RESTRICT=test

ruby_add_rdepend ">=dev-ruby/shoulda-context-1.0.1
	dev-ruby/shoulda-matchers:3"

all_ruby_prepare() {
	sed -e '/executables/,/^  end/d ; /test_files/d; s/git ls-files/find . -print/' -i ${RUBY_FAKEGEM_GEMSPEC} || die
}
