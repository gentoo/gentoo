# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.rdoc TODO"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_GEMSPEC="rake.gemspec"

inherit bash-completion-r1 ruby-fakegem

DESCRIPTION="Make-like scripting in Ruby"
HOMEPAGE="https://github.com/ruby/rake"
SRC_URI="https://github.com/ruby/rake/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="doc"

BDEPEND="app-alternatives/gzip"

ruby_add_bdepend "test? ( dev-ruby/test-unit )
	doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	sed -e 's/git ls-files -z/find * -type f -print0/' \
		-e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_compile() {
	if use doc; then
		rdoc --title "Rake - Ruby Make" --main README.rdoc --out html lib *.rdoc doc/*/*.rdoc || die
		rm -f html/js/*.js.gz
	fi
}

each_ruby_test() {
	MT_NO_PLUGINS=true RUBYLIB="$(pwd)/lib" ${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	ruby_fakegem_binwrapper rake

	if use doc; then
		pushd html
		dodoc -r *
		popd
	fi

	doman doc/rake.1

	newbashcomp "${FILESDIR}"/rake.bash-completion ${PN}
}
