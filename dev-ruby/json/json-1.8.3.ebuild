# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES TODO README.rdoc README-json-jruby.markdown"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="json.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A JSON implementation as a Ruby extension"
HOMEPAGE="https://github.com/flori/json"
LICENSE="|| ( Ruby GPL-2 )"

KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

RDEPEND="${RDEPEND}"
DEPEND="${DEPEND}
	dev-util/ragel"

ruby_add_bdepend "dev-ruby/rake
	doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	# Avoid building the extension twice!
	# And use rdoc instead of sdoc which we don't have packaged
	# And don't call git to list files. We're using the pregenerated spec anyway.
	sed -i \
		-e 's| => :compile||' \
		-e 's| => :clean||' \
		-e 's|sdoc|rdoc|' \
		-e 's|`git ls-files`|""|' \
		Rakefile || die "rakefile fix failed"

	# Remove hardcoded and broken -O setting.
	sed -i -e '/^  \(if\|unless\)/,/^  end/ s:^:#:' \
		-e '/^unless/,/^end/ s:^:#:' ext/json/ext/*/extconf.rb || die
}

each_ruby_compile() {
	# Since 1.5.0 a Java extension is provided but it does not compile.
	if [[ $(basename ${RUBY}) != "jruby" ]]; then
		${RUBY} -S rake compile || die "extension compile failed"
	fi
}

each_ruby_test() {
	JSON=pure \
	${RUBY} -Iext:lib -S testrb tests/test_*.rb || die "pure ruby tests failed"

	if [[ $(basename ${RUBY}) != "jruby" ]]; then
		JSON=ext \
		${RUBY} -Iext:lib -S testrb tests/test_*.rb || die "ext ruby tests failed"
	fi
}

each_ruby_install() {
	each_fakegem_install
	if [[ $(basename ${RUBY}) != "jruby" ]]; then
		ruby_fakegem_newins ext/json/ext/generator$(get_modname) lib/json/ext/generator$(get_modname)
		ruby_fakegem_newins ext/json/ext/parser$(get_modname) lib/json/ext/parser$(get_modname)
	fi
}
