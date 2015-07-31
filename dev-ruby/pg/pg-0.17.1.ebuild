# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pg/pg-0.17.1.ebuild,v 1.10 2015/07/31 15:12:15 ago Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog Contributors.rdoc README.rdoc History.rdoc"

inherit multilib ruby-fakegem

DESCRIPTION="Ruby extension library providing an API to PostgreSQL"
HOMEPAGE="http://bitbucket.org/ged/ruby-pg/"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="${RDEPEND}
	dev-db/postgresql"
DEPEND="${DEPEND}
	dev-db/postgresql
	test? ( dev-db/postgresql[server,threads] )"

ruby_add_bdepend "
	doc? (
		dev-ruby/hoe
		|| ( >=dev-ruby/yard-0.6.1 dev-ruby/rdoc ) )"

all_ruby_prepare() {
	# hack the Rakefile to make it sure that it doesn't load
	# rake-compiler (so that we don't have to depend on it and it
	# actually works when building with USE=doc).
	sed -i \
		-e '/Rakefile.cross/s:^:#:' \
		-e '/ExtensionTask/,/^end$/ s:^:#:' \
		Rakefile || die

	sed -i -e '18i require "socket"' spec/pg/connection_spec.rb || die
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
		ruby-ng_rspec
	else
		ewarn "The userpriv feature must be enabled to run tests."
		eerror "Testsuite will not be run."
	fi
}
