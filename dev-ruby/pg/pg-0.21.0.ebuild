# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog Contributors.rdoc README.rdoc History.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby extension library providing an API to PostgreSQL"
HOMEPAGE="https://bitbucket.org/ged/ruby-pg/"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ppc ~ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND+=" dev-db/postgresql:*"
DEPEND+=" dev-db/postgresql
	test? ( >=dev-db/postgresql-9.4[server,threads] )"

PATCHES=( "${FILESDIR}/postgresql10-tests.patch" )

all_ruby_prepare() {
	# hack the Rakefile to make it sure that it doesn't load
	# rake-compiler (so that we don't have to depend on it and it
	# actually works when building with USE=doc).
	sed -i \
		-e '/Rakefile.cross/s:^:#:' \
		-e '/ExtensionTask/,/^end$/ s:^:#:' \
		Rakefile || die
}

each_ruby_configure() {
	${RUBY} -C ext extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake V=1 -C ext CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
	cp ext/*$(get_libname) lib || die
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
