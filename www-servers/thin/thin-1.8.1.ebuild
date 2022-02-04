# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A fast and very simple Ruby web server"
HOMEPAGE="http://code.macournoyer.com/thin/"
SRC_URI="https://github.com/macournoyer/thin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc test"

DEPEND="${DEPEND}
	dev-util/ragel"
RDEPEND="${RDEPEND}"

# The runtime dependencies are used at build-time as well since the
# Rakefile loads thin!
mydeps=">=dev-ruby/daemons-1.0.9
	>=dev-ruby/rack-1.0.0:* <dev-ruby/rack-3:*
	>=dev-ruby/eventmachine-1.0.4:0
	virtual/ruby-ssl"

ruby_add_rdepend "${mydeps}"
ruby_add_bdepend "${mydeps}
	dev-ruby/rake-compiler"

all_ruby_prepare() {
	# Fix Ragel-based parser generation (uses a *very* old syntax that
	# is not supported in Gentoo)
	sed -i -e 's: | rlgen-cd::' Rakefile || die

	# Fix specs' dependencies so that the extension is not rebuilt
	# when running tests
	rm tasks/spec.rake || die

	# Fix rspec version to allow newer 2.x versions
	sed -i -e '/gem "rspec"/ s/1.2.9/2.0/' spec/spec_helper.rb || die

	# Avoid CLEAN since it may not be available and we don't need it.
	sed -i -e '/CLEAN/ s:^:#:' tasks/*.rake || die

	# Disable a test that is known for freezing the testsuite,
	# reported upstream. In thin 1.5.1 this just fails.
	sed -i \
		-e '/should force kill process in pid file/,/^  end/ s:^:#:' \
		spec/daemonizing_spec.rb || die

	sed -i \
		-e '/tracing routines (with NO custom logger)/,/^  end/ s:^:#:'\
		spec/logging_spec.rb || die

	find spec/perf -name "*_spec.rb" -exec \
		sed -i '/be_faster_then/ i \    pending' {} \;

	sed -i -e "s/Spec::Runner/Rspec/" spec/spec_helper.rb || die
	# nasty but too complex to fix up for now :(
	use doc || rm tasks/rdoc.rake
}

each_ruby_compile() {
	${RUBY} -S rake compile || die "rake compile failed"
}

all_ruby_install() {
	all_fakegem_install

	keepdir /etc/thin
	newinitd "${FILESDIR}"/${PN}.initd-r4 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-2 ${PN}

	einfo
	elog "Thin is now shipped with init scripts."
	elog "The default script (/etc/init.d/thin) will start all servers that have"
	elog "configuration files in /etc/thin/. You can symlink the init script to"
	elog "files of the format 'thin.SERVER' to be able to start individual servers."
	elog "See /etc/conf.d/thin for more configuration options."
	einfo
}
