# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc Manifest.txt README.rdoc"

RUBY_FAKEGEM_EXTRAINSTALL="template"

inherit ruby-fakegem

DESCRIPTION="Hoe extends rake to provide full project automation"
HOMEPAGE="https://zenspider.com/projects/hoe.html"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="doc"

ruby_add_bdepend "test? ( >=dev-ruby/rdoc-6 >=dev-ruby/minitest-5.9:5 )"

ruby_add_rdepend "=dev-ruby/rake-13*"

all_ruby_prepare() {
	# Skip isolation
	sed -i -e '/isolate/ s:^:#:' Rakefile || die

	# Skip test depending on specifics of gem command name
	sed -i -e '/test_nosudo/,/^  end/ s:^:#:' test/test_hoe.rb || die

	# Avoid test with random sort order
	sed -i -e '/test_possibly_better/askip "ordering issues"' test/test_hoe.rb || die

	# Avoid test that depends on specifics of merged packages
	sed -i -e '/test_make_rdoc_cmd/askip "dependent on merged packages"' test/test_hoe_publish.rb || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc; then
		rdoc --title "seattlerb's hoe-${PV} Documentation" -o doc --main README.rdoc \
			 lib History.rdoc Manifest.txt README.doc || die
		rm -f doc/js/*.gz || die
	fi
}

each_ruby_test() {
	export -n A
	each_fakegem_test
}
