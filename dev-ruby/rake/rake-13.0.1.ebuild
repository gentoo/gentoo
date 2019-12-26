# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND+=" app-arch/gzip"

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.8 )
	doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

all_ruby_compile() {
	if use doc; then
		rdoc --title "Rake - Ruby Make" --main README.rdoc --out html lib *.rdoc doc/*/*.rdoc || die
		rm -f html/js/*.js.gz
	fi
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'gem "minitest", "~>5.8"; require "minitest/autorun"; Dir["test/test_*.rb"].each{|f| require f}' || die
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
