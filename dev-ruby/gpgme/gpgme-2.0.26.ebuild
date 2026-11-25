# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/gpgme/extconf.rb)

RUBY_FAKEGEM_EXTRADOC="NEWS README.rdoc"

inherit edo ruby-fakegem

DESCRIPTION="Ruby language binding for GnuPG Made Easy"
HOMEPAGE="https://github.com/ueno/ruby-gpgme"

SRC_URI="https://github.com/ueno/ruby-gpgme/archive/v${PV}.tar.gz -> ruby-${P}.tar.gz"
RUBY_S="ruby-${P}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=app-crypt/gpgme-1.18.0:=
	>=dev-libs/libassuan-2.5.6:=
	>=dev-libs/libgpg-error-1.47
"
DEPEND="${RDEPEND}"

ruby_add_bdepend "
	test? (
		>=dev-ruby/mocha-2:*
		>=dev-ruby/minitest-5:*
	)
"

PATCHES=(
	"${FILESDIR}"/gpgme-2.0.26-mocha2.patch
	"${FILESDIR}"/gpgme-2.0.26-minitest6.patch
	"${FILESDIR}"/gpgme-2.0.26-fix-test.patch
)

all_ruby_prepare() {
	sed -i -e '/\(coverall\|bundler\|ruby-debug\|byebug\)/I s:^:#:' \
		-e '3igem "mocha", "~> 2"; gem "minitest", ">= 5"' \
		test/test_helper.rb || die

	sed -i -e '/portile/d ; /rubyforge/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_configure() {
	export RUBY_GPGME_USE_SYSTEM_LIBRARIES=1
	each_fakegem_configure
}

each_ruby_test() {
	unset DISPLAY GPG_AGENT_INFO GPG_TTY

	local -x MT_NO_PLUGINS=true
	# Run tests by hand due to tests being order dependant (newer minitest adds randomness)
	for test_file in test/*_test.rb; do
		edo ${RUBY} -Ilib:test:. -e "require '${test_file}'" || die
	done
}
