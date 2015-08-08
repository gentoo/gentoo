# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC="moot" # we do it manually, but still declare it
RUBY_FAKEGEM_DOCDIR="html"
RUBY_FAKEGEM_EXTRADOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="mongodb"
GITHUB_PROJECT="mongo-ruby-driver"
RUBY_S="${GITHUB_PROJECT}-${PV}"

inherit multilib ruby-fakegem

DESCRIPTION="A Ruby BSON implementation for MongoDB. (Includes binary C-based extension.)"
HOMEPAGE="http://www.mongodb.org/"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/archive/${PV}.tar.gz -> ${GITHUB_PROJECT}-${PV}.tar.gz"

LICENSE="APSL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test doc"

ruby_add_bdepend \
	"test? (
		dev-ruby/bundler
		>=dev-ruby/rake-10.1
		dev-ruby/sfl
		>=dev-ruby/shoulda-3.3.2
		dev-ruby/mocha
		dev-ruby/test-unit:2
	)
	doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	# remove the stuff that is actually part of dev-ruby/mongo
	rm -f bin/mongo* || die

	# Avoid test dependency on pry
	sed -i -e '/\(pry\|coverall\)/I s:^:#:' Gemfile tasks/testing.rake test/test_helper.rb || die
	# Avoid deployment dependencies and fix version issues
	sed -i -e '/rest-client/ s/1.6.8/~> 1.6/' \
		-e '/test-unit/ s/~>2.0/>= 2.0/' \
		-e '/rake/ s/10.1.1/~>10.1/' \
		-e '/:deploy/,/end/ s:^:#:' Gemfile || die

	# Don't clean up the compiled version after testing
	sed -i -e '/:cleanup/,/end/ s:lib/bson_ext::' tasks/testing.rake || die
}

each_ruby_configure() {
	${RUBY} -C ext/cbson extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -C ext/cbson V=1 CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
	mkdir -p lib/bson_ext || die
	cp ext/cbson/*$(get_modname) lib/bson_ext || die
}

all_ruby_compile() {
	# Trying to get the Rakefile to build the sources is more trouble
	# than it's worth, do it manually instead.
	if use doc; then
		rdoc --op html --inline-source lib/**/*.rb || die "rdoc failed"
	fi
}

each_ruby_test() {
	C_EXT=true JENKINS_CI=true ${RUBY} -S rake test:bson || die "tests failed"
}

each_ruby_install() {
	# Remove remaining mongo code that will be installed as part of
	# dev-ruby/mongo. We do this here rather than in src_prepare so we
	# can bootstrap with tests enabled.
	rm -rf lib/mongo* || die

	# we have to set the library path here because the gemspec tries to
	# load bson itself, and would fail without that.
	RUBYLIB="lib" \
		each_fakegem_install

	# and now we create the simulated gem for bson_ext; we create a file
	# bson_ext.rb within ext so that we don't have to change the
	# bson_ext.gemspec file, and at the same time we ensure that bson
	# gem is loaded when loading bson_ext.
	dodir $(ruby_fakegem_gemsdir)/gems/bson_ext-${PV}/ext
	cat - <<EOF > "${D}/$(ruby_fakegem_gemsdir)/gems/bson_ext-${PV}/ext/bson_ext.rb"
require 'bson'
EOF

	RUBYLIB="lib" \
		RUBY_FAKEGEM_NAME=bson_ext \
		RUBY_FAKEGEM_GEMSPEC=bson_ext.gemspec \
		ruby_fakegem_install_gemspec
}

pkg_postinst() {
	elog "Unlike upstream setup, we do not split bson and bson_ext gem."
	elog "This means that for all the supported targets, the C-based extension"
	elog "is installed by this package, and is available transparently."
}
