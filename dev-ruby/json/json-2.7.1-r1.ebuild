# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"
RUBY_FAKEGEM_DOCDIR="doc"

RUBY_FAKEGEM_GEMSPEC="json.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/json/ext/parser/extconf.rb ext/json/ext/generator/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/json/ext

inherit ruby-fakegem

DESCRIPTION="A JSON implementation as a Ruby extension"
HOMEPAGE="https://github.com/flori/json"
SRC_URI="https://github.com/flori/json/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( BSD-2 Ruby )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="$(ver_cut 1)"
IUSE=""

RDEPEND="${RDEPEND}"
DEPEND="${DEPEND}
	dev-util/ragel"

ruby_add_bdepend "dev-ruby/rake
	doc? ( dev-ruby/rdoc )
	test? ( dev-ruby/test-unit:2 )"

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

	sed -e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid setting gem since it will not be available yet when installing
	sed -i -e '/gem/ s:^:#:' tests/test_helper.rb || die
}
