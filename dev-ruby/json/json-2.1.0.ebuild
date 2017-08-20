# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="json.gemspec"

inherit multilib ruby-fakegem

DESCRIPTION="A JSON implementation as a Ruby extension"
HOMEPAGE="https://github.com/flori/json"
LICENSE="Ruby"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="2"
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
		-e '/task :test/ s|:compile,||' \
		-e 's| => :clean||' \
		-e 's|sdoc|rdoc|' \
		-e 's|`git ls-files`|""|' \
		Rakefile || die "rakefile fix failed"

	# Remove hardcoded and broken -O setting.
	sed -i -e '/^  \(if\|unless\)/,/^  end/ s:^:#:' \
		-e '/^unless/,/^end/ s:^:#:' ext/json/ext/*/extconf.rb || die

	# Avoid setting gem since it will not be available yet when installing
	sed -i -e '/gem/ s:^:#:' tests/test_helper.rb || die
}

each_ruby_configure() {
	for ext in parser generator ; do
		${RUBY} -Cext/json/ext/${ext} extconf.rb || die
	done
}

each_ruby_compile() {
	for ext in parser generator ; do
		emake V=1 -Cext/json/ext/${ext}
		cp ext/json/ext/${ext}/${ext}$(get_modname) ext/json/ext/ || die
	done
}

each_ruby_test() {
	for t in pure ext ; do
		JSON=${T} ${RUBY} -S rake do_test_${t} || die
	done
}

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_newins ext/json/ext/generator$(get_modname) lib/json/ext/generator$(get_modname)
	ruby_fakegem_newins ext/json/ext/parser$(get_modname) lib/json/ext/parser$(get_modname)
}
