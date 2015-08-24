# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem eutils

DESCRIPTION="A fast and liberal HTML parser for Ruby"
HOMEPAGE="https://wiki.github.com/hpricot/hpricot"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend "dev-ruby/rake
	dev-ruby/rake-compiler"

# dev-ruby/fast_xs does not cover JRuby so still bundle it here for now
USE_RUBY="${USE_RUBY/jruby/}" \
	ruby_add_rdepend "dev-ruby/fast_xs"

# Probably needs the same jdk as JRuby but I'm not sure how to express
# that just yet.
DEPEND+="
	dev-util/ragel"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Fix encoding assumption of environment for Ruby 1.9.
	# https://github.com/hpricot/hpricot/issues/52
	# sed -i -e '1 iEncoding.default_external=Encoding::UTF_8 if RUBY_VERSION =~ /1.9/' test/load_files.rb || die
}

each_ruby_prepare() {
	# dev-ruby/fast_xs does not cover JRuby so still bundle it here for now
	[[ ${RUBY} == */jruby ]] && return

	pushd .. &>/dev/null
	epatch "${FILESDIR}"/${P}-fast_xs.patch
	popd .. &>/dev/null
}

each_ruby_configure() {
	# dev-ruby/fast_xs does not cover JRuby so still bundle it here for now
	[[ ${RUBY} == */jruby ]] && return

	${RUBY} -Cext/hpricot_scan extconf.rb || die "hpricot_scan/extconf.rb failed"
}

each_ruby_compile() {
	local modname=$(get_modname)

	# dev-ruby/fast_xs does not cover JRuby so still bundle it here for now
	if [[ ${RUBY} == */jruby ]]; then
		${RUBY} -S rake compile_java || die "rake compile_java failed"
		return
	fi

	emake V=1 -Cext/hpricot_scan CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" || die "make hpricot_scan failed"
	cp ext/hpricot_scan/hpricot_scan${modname} lib/ || die
}
