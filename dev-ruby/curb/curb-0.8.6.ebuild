# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby-language bindings for libcurl"
HOMEPAGE="http://curb.rubyforge.org/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND+=" net-misc/curl[ssl]"
RDEPEND+=" net-misc/curl[ssl]"

all_ruby_prepare() {
	# fix tests when localhost is also ::1
	sed -i -e 's|localhost:|127.0.0.1:|g' tests/*.rb || die

	# avoid tests making outside network connections
	rm tests/bug_postfields_crash.rb || die
	sed -e '/test_easy_http_verbs_must_respond_to_str/,/^  end/ s:^:#:' \
		-i tests/tc_curl_easy.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext CFLAGS="${CFLAGS} -fPIC" archflags="${LDFLAGS}" V=1
	cp -l ext/curb_core$(get_modname) lib || die
}
