# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"
PYTHON_COMPAT=( python2_7 )

RUBY_FAKEGEM_NAME="pygments.rb"
MY_P="${RUBY_FAKEGEM_NAME}-${PV}"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${RUBY_FAKEGEM_NAME}.gemspec"

inherit ruby-fakegem python-single-r1

DESCRIPTION="Pygments syntax highlighting in ruby"
HOMEPAGE="https://github.com/tmm1/pygments.rb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"

RUBY_S="${MY_P}"

RDEPEND+="
	${PYTHON_DEPS}
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]"
DEPEND+=" test? ( ${RDEPEND} )"

ruby_add_rdepend ">=dev-ruby/yajl-ruby-1.2
	dev-ruby/posix-spawn"
ruby_add_bdepend "dev-ruby/rake-compiler"

pkg_setup() {
	ruby-ng_pkg_setup
	python-single-r1_pkg_setup
}

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/s.files/d' pygments.rb.gemspec || die
	python_fix_shebang lib/pygments/mentos.py
	# we are loosing a "custom github lexer here", no idea what it is,
	# but if we need it, it should go into dev-python/pygments
	rm -r vendor lexers || die "removing bundled libs failed"
}

each_ruby_compile() {
	# regenerate the lexer cache, based on the system pygments pkg
	${RUBY} cache-lexers.rb || die "regenerating lexer cache failed"
}

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_doins lexers
}
