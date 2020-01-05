# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6,3_7} )
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_NAME="RbST"
RUBY_FAKEGEM_GEMSPEC="RbST.gemspec"

inherit python-single-r1 ruby-fakegem

DESCRIPTION="A simple Ruby wrapper for processing rST via docutils"
HOMEPAGE="https://github.com/alphabetum/rbst"
SRC_URI="https://github.com/alphabetum/rbst/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="dev-python/docutils ${PYTHON_DEPS}"
DEPEND="test? ( ${RDEPEND} )"

ruby_add_bdepend "
	test? (
		>=dev-ruby/mocha-1.1.0:1.0
		>=dev-ruby/shoulda-3.5.0:3
		>=dev-ruby/test-unit-3.0.9:2
	)"

# Tests are pretty much useless as they depend on very specific output
# from an unknown docutils version.
RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
	ruby-ng_pkg_setup
}

all_ruby_prepare() {
	# do not use bundler
	sed -i -e '/bundler/,/end/d' \
		Rakefile test/helper.rb || die

	# force our python version
	sed -i -e "s:\(python_path=\"\)python:\1${EPYTHON}:" lib/rbst.rb || die
	python_fix_shebang lib/rst2parts
}
