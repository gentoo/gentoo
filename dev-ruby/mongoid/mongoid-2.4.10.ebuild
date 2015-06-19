# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mongoid/mongoid-2.4.10.ebuild,v 1.2 2014/05/26 05:30:14 mrueg Exp $

EAPI=4
USE_RUBY="ruby19"

#RUBY_FAKEGEM_TASK_DOC=""
# functional testing crashes Ruby from within Portage, but works
# outside of it, needs to be investigated thoroughly, but at least
# unit testing works.
RUBY_FAKEGEM_TASK_TEST="spec:unit spec:functional"

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="${PN}"
GITHUB_PROJECT="${PN}"
RUBY_S="${GITHUB_USER}-${GITHUB_PROJECT}-*"

inherit ruby-fakegem

DESCRIPTION="ODM (Object Document Mapper) Framework for MongoDB"
HOMEPAGE="http://mongoid.org/"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/tarball/v${PV} -> ${GITHUB_PROJECT}-${PV}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/activemodel-3.1
	>=dev-ruby/mongo-1.6
	>=dev-ruby/tzinfo-0.3.22
"

ruby_add_bdepend "
	test? (
		dev-ruby/ammeter
		dev-ruby/mocha
		dev-ruby/rdoc
		dev-ruby/rspec
		dev-util/watchr
	)"

DEPEND+=" test? ( dev-db/mongodb )"

all_ruby_prepare() {
	# remove references to bundler, as the gemfile does not add anything
	# we need to care about.
	sed -i -e '/[bB]undler/d' Rakefile || die
	# remove the Gemfile as well or it'll try to load it during testing
	rm Gemfile || die

	#epatch "${FILESDIR}"/${PN}-2.4.5-gentoo.patch
}

each_ruby_test() {
	mkdir "${T}/mongodb_$(basename $RUBY)"
	mongod --port 27017 --dbpath "${T}/mongodb_$(basename $RUBY)" \
		--noprealloc --noauth --nohttpinterface --nounixsocket --nojournal \
		--bind_ip 127.255.255.254 &
	mongod_pid=$!
	failed=0

	sleep 2

	export MONGOID_SPEC_HOST="127.255.255.254"
	export MONGOID_SPEC_PORT="27017"

	${RUBY} -S rake ${RUBY_FAKEGEM_TASK_TEST} || failed=1
	kill "${mongod_pid}"

	[[ "${failed}" == "1" ]] && die "tests failed"
}
