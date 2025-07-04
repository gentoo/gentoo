# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Making tests easy on the fingers and eyes"
HOMEPAGE="https://github.com/thoughtbot/shoulda"
SRC_URI="https://github.com/thoughtbot/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc ~x86"

# This now more or less a meta-gem and it only contains features for
# integration tests using Appraisals, which we don't currently package.
RESTRICT=test

ruby_add_rdepend "
	dev-ruby/shoulda-context:2
	dev-ruby/shoulda-matchers:4"

all_ruby_prepare() {
	sed -e '/executables/,/^  end/d ; /test_files/d; s/git ls-files/find * -print/' -i ${RUBY_FAKEGEM_GEMSPEC} || die
}
