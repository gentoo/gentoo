# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="ChangeLog Contributors.rdoc README.rdoc History.rdoc"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby extension library providing an API to PostgreSQL"
HOMEPAGE="https://github.com/ged/ruby-pg"

LICENSE="|| ( BSD-2 Ruby-BSD )"
SLOT="1"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND+=" dev-db/postgresql:*"
DEPEND+=" dev-db/postgresql
	test? ( >=dev-db/postgresql-9.4[server(+),threads] )"

all_ruby_prepare() {
	# hack the Rakefile to make it sure that it doesn't load
	# rake-compiler (so that we don't have to depend on it and it
	# actually works when building with USE=doc).
	sed -i \
		-e '/Rakefile.cross/s:^:#:' \
		-e '/ExtensionTask/,/^end$/ s:^:#:' \
		Rakefile || die
}

each_ruby_test() {
	if [[ "${EUID}" -ne "0" ]]; then
		# Make the rspec call explicit, this way we don't have to depend
		# on rake-compiler (nor rubygems) _and_ we don't have to rebuild
		# the whole extension from scratch.
		RSPEC_VERSION=3 ruby-ng_rspec
	else
		ewarn "The userpriv feature must be enabled to run tests."
		eerror "Testsuite will not be run."
	fi
}
