# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md KNOWN-ISSUES README.rdoc SPEC"

inherit ruby-fakegem eutils versionator

DESCRIPTION="A modular Ruby webserver interface"
HOMEPAGE="https://rack.github.com/"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=( ${PN}-1.2.1-gentoo.patch )

ruby_add_rdepend "virtual/ruby-ssl"

# The gem has automagic dependencies over mongrel, ruby-openid,
# memcache-client, thin, mongrel and camping; not sure if we should
# make them dependencies at all.
ruby_add_bdepend "test? ( dev-ruby/bacon )"

# Block against versions in older slots that also try to install a binary.
RDEPEND="${RDEPEND} !<dev-ruby/rack-1.4.5-r1:1.4 !<dev-ruby/rack-1.5.2-r4:1.5"

all_ruby_prepare() {
	# The build system tries to generate the ChangeLog from git. Create
	# an empty file to avoid a needless dependency on git.
	touch ChangeLog || die
}

each_ruby_test() {
	# Since the Rakefile calls specrb directly rather than loading it, we
	# cannot use it to launch the tests or only the currently-selected
	# RUBY interpreter will be tested.
	${RUBY} -S bacon -Ilib -w -a \
		-q -t '^(?!Rack::Handler|Rack::Adapter|Rack::Session::Memcache|Rack::Server)' \
		|| die "test failed for ${RUBY}"
}
