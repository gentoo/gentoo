# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md History"

RUBY_FAKEGEM_GEMSPEC="crack.gemspec"

inherit ruby-fakegem

DESCRIPTION="Really simple JSON and XML parsing, ripped from Merb and Rails"
HOMEPAGE="https://github.com/jnunemaker/crack"
SRC_URI="https://github.com/jnunemaker/crack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-psych4.patch" )

ruby_add_rdepend "dev-ruby/rexml"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Also list rexml in the gemspec. This is fixed upstream in 0.4.5 but that version is not tagged.
	sed -i -e '17igem.add_runtime_dependency("rexml")' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	# Remove tests which fail when run by portage but pass when run by hand
	sed -i -e '/{"regex": \/foo.*\/}/d' test/json_test.rb || die
	sed -i -e '/{"regex": \/foo.*\/i}/d' test/json_test.rb || die
	sed -i -e '/{"regex": \/foo.*\/mix}/d' test/json_test.rb || die
}

each_ruby_test() {
	${RUBY} -Itest -Ilib -e 'Dir["test/*_test.rb"].each { |f| load f }' || die
}
