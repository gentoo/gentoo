# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_NAME="RbST"
RUBY_FAKEGEM_GEMSPEC="RbST.gemspec"

inherit python-single-r1 ruby-fakegem

DESCRIPTION="A simple Ruby wrapper for processing rST via docutils"
HOMEPAGE="https://github.com/xwmx/rbst/"
SRC_URI="
	https://github.com/xwmx/rbst/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	dev-python/docutils
	${PYTHON_DEPS}
"
DEPEND="
	test? ( ${RDEPEND} )
"

ruby_add_bdepend "
	test? (
		>=dev-ruby/minitest-5.14.0:5
		dev-ruby/mocha:2
	)
"

pkg_setup() {
	python-single-r1_pkg_setup
	ruby-ng_pkg_setup
}

all_ruby_prepare() {
	# do not use bundler
	sed -i -e '/bundler/,/end/d' \
		Rakefile test/helper.rb || die
	# do not use python2
	sed -i -e '/python2/,/end/d' \
		test/test_rbst.rb || die
	# broken by new docutils
	sed -i -e '/it.*LaTeX/,/end/d' \
		test/test_rbst.rb || die

	# force our python version
	sed -i -e "s:\(python_path=\"\)python:\1${EPYTHON}:" lib/rbst.rb || die
	python_fix_shebang lib/rst2parts

	# Update test file for latest docutils output
	sed -e '/footnote/ s/id1/footnote-1/' \
		-e '/backref/ s/id3/footnote-reference-1/' \
		-e '/backref/ s/id4/citation-reference-1/' \
		-e '/footnote-reference/ s/id3/footnote-reference-1/' \
		-e '/citation-reference/ s/id4/citation-reference-1/' \
		-i test/files/test.html || die
}
