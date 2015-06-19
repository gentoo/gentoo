# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/thin/thin-1.6.3.ebuild,v 1.2 2014/11/04 18:51:01 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="spec:main spec:group:0 spec:group:1 spec:group:2"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A fast and very simple Ruby web server"
HOMEPAGE="http://code.macournoyer.com/thin/"
SRC_URI="https://github.com/macournoyer/thin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc test"

DEPEND="${DEPEND}
	dev-util/ragel"
RDEPEND="${RDEPEND}"

# The runtime dependencies are used at build-time as well since the
# Rakefile loads thin!
mydeps=">=dev-ruby/daemons-1.0.9
	>=dev-ruby/rack-1.0.0
	>=dev-ruby/eventmachine-1.0.0
	virtual/ruby-ssl"

ruby_add_rdepend "${mydeps}"
ruby_add_bdepend "${mydeps}
	dev-ruby/rake-compiler
	test? ( dev-ruby/rspec:0 )"

all_ruby_prepare() {
	# Fix Ragel-based parser generation (uses a *very* old syntax that
	# is not supported in Gentoo)
	sed -i -e 's: | rlgen-cd::' Rakefile || die

	# Fix specs' dependencies so that the extension is not rebuilt
	# when running tests
	sed -i -e '/:spec =>/s:^:#:' tasks/spec.rake || die

	# Fix rspec version to allow newer 1.x versions
	sed -i -e '/gem "rspec"/ s/1.2.9/1.0/' tasks/spec.rake spec/spec_helper.rb || die

	# Avoid CLEAN since it may not be available and we don't need it.
	sed -i -e '/CLEAN/ s:^:#:' tasks/*.rake || die

	# Disable a test that is known for freezing the testsuite,
	# reported upstream. In thin 1.5.1 this just fails.
	sed -i \
		-e '/should force kill process in pid file/,/^  end/ s:^:#:' \
		spec/daemonizing_spec.rb || die

	# nasty but too complex to fix up for now :(
	use doc || rm tasks/rdoc.rake
	use test || rm tasks/spec.rake
}

each_ruby_compile() {
	${RUBY} -S rake compile || die "rake compile failed"
}

all_ruby_install() {
	all_fakegem_install

	keepdir /etc/thin
	newinitd "${FILESDIR}"/${PN}.initd-2 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-2 ${PN}

	einfo
	elog "Thin is now shipped with init scripts."
	elog "The default script (/etc/init.d/thin) will start all servers that have"
	elog "configuration files in /etc/thin/. You can symlink the init script to"
	elog "files of the format 'thin.SERVER' to be able to start individual servers."
	elog "See /etc/conf.d/thin for more configuration options."
	einfo
}
